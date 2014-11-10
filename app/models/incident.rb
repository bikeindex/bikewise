class Incident < ActiveRecord::Base
  # Attributes: incident_type_id, status, description, title, occurred_at
  #             address, latitude, longitude, country_id
  #             image_url, image_url_thumb
  #             create_open311_report, has_open311_report,
  #             open311_is_acknowledged, open311_is_closed

  has_many :incident_reports
  has_many :binx_reports, through: :incident_reports, source: :report, source_type: 'BinxReport'
  has_many :scf_reports, through: :incident_reports, source: :report, source_type: 'ScfReport'
  has_many :bw_reports, through: :incident_reports, source: :report, source_type: 'BwReport'

  belongs_to :country 
  belongs_to :user
  belongs_to :incident_type

  serialize :source
  serialize :additional_sources
  geocoded_by :address

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
    connection.select_all(select([:latitude, :longitude, :id, :type_name]).arel).map { |attrs|
      { type: "Feature",
        properties: {
          id: attrs['id'].to_i,
          type: attrs['type_name']
        },
        geometry: {
          type: "Point",
          coordinates: [attrs['longitude'].to_f, attrs['latitude'].to_f]}
      }
    }
  end

end
