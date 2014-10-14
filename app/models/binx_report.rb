class BinxReport < ActiveRecord::Base
  include Reportable
  #   binx -> BikeIndex
  # 
  # Attributes: binx_id
  # 
  # Note: external_api_id refers to the stolen_record id of the bike - since a 
  #       bike could be stolen multiple times

  def self.id_from_external_hash(hash)
    hash[:bikes][:stolen_record][:id]
  end

  def set_attrs_from_hash
    self.external_api_hash = external_api_hash[:bikes] if external_api_hash[:bikes].present?
    self.binx_id = external_api_hash[:id]
    self.external_api_updated_at = Time.parse(external_api_hash[:registration_updated_at])
    self.source = source_hash
  end

  def incident_attrs
    hash = {
      latitude: external_api_hash[:stolen_record][:latitude],
      longitude: external_api_hash[:stolen_record][:longitude],
      address: external_api_hash[:stolen_record][:location].gsub(/\A(,\s?)+/,''),
      title: "Stolen #{external_api_hash[:title]}",
      description: external_api_hash[:stolen_record][:theft_description],
      image_url: external_api_hash[:photo],
      image_url_thumb: external_api_hash[:thumb],
      create_open311_report: external_api_hash[:stolen_record][:create_open311],
      occurred_at: Time.parse(external_api_hash[:stolen_record][:date_stolen]),
      incident_type_id: incident_type_id,
    }
  end

  def is_open311_report
    false
  end

  def incident_type_id
    IncidentType.find_or_create_by(slug: 'theft').id
  end

  def source_hash
    {
      name: "BikeIndex.org",
      html_url: external_api_hash[:url],
      api_url: external_api_hash[:api_url]
    }
  end

  def hash_updated_at(hash)
    Time.parse(hash[:bikes][:registration_updated_at])
  end

end
