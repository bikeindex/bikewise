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
    return true if external_api_hash[:status].match(/bi(cycle|ke)/i).present?
    return true if external_api_hash[:description].match(/bi(cycle|ke)/i).present?
    false
  end

  def incident_attrs
    hash = {
      latitude: external_api_hash[:lat],
      longitude: external_api_hash[:lng],
      address: external_api_hash[:address],
      title: external_api_hash[:status],
      description: external_api_hash[:description],
      image_url: external_api_hash[:media][:image_full],
      image_url_thumb: external_api_hash[:media][:image_square_100x100],
      occurred_at: Time.parse(external_api_hash[:created_at]),
      incident_type_id: incident_type_id
    }
  end

  def incident_type_id
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
