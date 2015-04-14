class Incident < ActiveRecord::Base
  # Attributes: incident_type_id, status, description, title, occurred_at, user_id
  #             address, latitude, longitude, country_id
  #             image_url, image_url_thumb
  #             create_open311_report, has_open311_report,
  #             open311_is_acknowledged, open311_is_closed
  #             age, name, experience_level_select_id, gender_select_id

  has_many :incident_reports
  has_many :binx_reports, through: :incident_reports, source: :report, source_type: 'BinxReport'
  has_many :scf_reports, through: :incident_reports, source: :report, source_type: 'ScfReport'
  has_many :bw_reports, through: :incident_reports, source: :report, source_type: 'BwReport'
  has_many :images

  belongs_to :experience_level_select, class_name: "Selection"
  belongs_to :gender_select, class_name: "Selection"
  belongs_to :location_select, class_name: "Selection"

  belongs_to :country
  belongs_to :user
  belongs_to :incident_type

  serialize :source
  serialize :additional_sources
  geocoded_by :address

  belongs_to :type_properties, polymorphic: true

  after_validation :geocode, unless: ->(obj){ obj.latitude.present? && obj.longitude.present? }

  include PgSearch
  pg_search_scope :search_text, against: {
    title: 'A',
    description:   'B',
  },
  using: {tsearch: {dictionary: "english", prefix: true}}

  default_scope { order('occurred_at DESC') } 

  before_save :store_type_name_and_sources
  def store_type_name_and_sources
    self.incident_type = IncidentType.find_or_create_by(name: 'Unconfirmed') unless self.incident_type_id.present?
    self.type_name = incident_type.name
    self.additional_sources = []
    self.occurred_at_stamp = (occurred_at || created_at).to_i
    incident_reports.each { |ir| self.additional_sources << ir.report.source_hash }
    source_report = incident_reports.where(is_incident_source: true).first
    if source_report.present?
      self.source = source_report.report.source_hash 
      self.source_type = source_report.report_type
      self.additional_sources.delete(source)
    end
    true
  end

  # Faster JSON serialization because GeoJSON with 10k+ results
  # http://brainspec.com/blog/2012/09/28/lightning-json-in-rails/
  def self.as_geojson
    connection.select_all(select([:latitude, :longitude, :id, :type_name, :occurred_at_stamp]).arel).map { |attrs|
      { type: "Feature",
        properties: {
          id: attrs['id'].to_i,
          type: attrs['type_name'],
          occurred_at: attrs['occurred_at_stamp'].to_i
        },
        geometry: {
          type: "Point",
          coordinates: [attrs['longitude'].to_f, attrs['latitude'].to_f]}
      }
    }
  end

  def mapbox_title
    "#{title.gsub(/\([^\)]*\)/, '').strip} (#{I18n.l occurred_at, format: :mapbox_time_display})"
  end

  def mapbox_color
    o = occurred_at 
    case 
    when o > Time.now - 1.day 
      "#E74C3C"
    when o > Time.now - 1.week
      "#EF8B80"
    when o > Time.now - 1.month
      "#F9CFCA"
    else
      "#EDEFF0"
    end
  end

  def mapbox_description
    d = image_url.present? ? "<img src='#{image_url}'> " : ''
    d += description + ' '
    d + ActionController::Base.helpers.link_to('View on Bike Index', source[:html_url], target: '_blank')
  end

  def mapbox_geojson
    {
      type: "Feature",
      properties: {
        id: id,
        title: mapbox_title,
        description: mapbox_description,
        occurred_at: occurred_at.to_s,
        :"marker-size" => "small",
        :"marker-color" => mapbox_color
      },
      geometry: {
        type: "Point",
        coordinates: [longitude.to_f, latitude.to_f]
      }
    }
  end

end
