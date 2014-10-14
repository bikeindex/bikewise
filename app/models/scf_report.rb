class ScfReport < ActiveRecord::Base
  include Reportable
  #   Scf ->  SeeClickFix
  # 
  # Attributes  is_bike_related,
  #             is_acknowledged, acknowledged_at, is_closed, closed_at

  def self.id_from_external_hash(hash)
    hash[:id]
  end

  def set_attrs_from_hash
    self.should_create_incident = check_if_bike_related
    self.external_api_updated_at = Time.parse(external_api_hash[:updated_at])
    self.source = source_hash
  end

  def check_if_bike_related
    return false unless external_api_hash.present?
    biky = /bi(cycle|ke)/i
    return true if external_api_hash[:summary].present? && external_api_hash[:summary].match(biky).present?
    return true if external_api_hash[:status].present? && external_api_hash[:status].match(biky).present?
    return true if external_api_hash[:description].present? && external_api_hash[:description].match(biky).present?
    false
  end

  def incident_attrs
    hash = {
      latitude: external_api_hash[:lat],
      longitude: external_api_hash[:lng],
      address: external_api_hash[:address],
      title: external_api_hash[:summary],
      description: external_api_hash[:description],
      image_url: external_api_hash[:media][:image_full],
      image_url_thumb: external_api_hash[:media][:image_square_100x100],
      occurred_at: Time.parse(external_api_hash[:created_at]),
      incident_type_id: incident_type_id
    }
  end

  def incident_type_id
    if external_api_hash[:description].present?
      it_slug = case external_api_hash[:description].downcase
        when /block.{1,20}bi(cycle|ke).lane/
          'hazard'
        when /safety (hazard)|(issue)/
          'hazard'
        when /someone (could)|(will) get hurt/
          'hazard'
      end
    end
    unless it_slug.present?
      it_slug = case external_api_hash[:summary].downcase
        when /(stolen)|(theft)|(abandoned)/
          'theft'
        when /policing issue/
          'theft'
        when /(pothole)|(hazard)/
          'hazard'
        when /parking enforcement/
          'hazard'
        when /bi(cycle|ke).(facilities)|infrastructure/
          'infrastructure issue'
        when /(replaced)|(traffic flow evaluation)/
          'infrastructure issue'
        when /signage/
          'infrastructure issue'
        when /(speed)|(repair)/
          'hazard'
      end
    end
    IncidentType.fuzzy_find_id(it_slug)
  end

  def is_open311_report
    true
  end

  def source_hash
    {
      name: "SeeClickFix.com",
      html_url: external_api_hash[:html_url],
      api_url: external_api_hash[:url]
    }
  end

  def hash_updated_at(hash)
    Time.parse(hash[:updated_at])
  end

end
