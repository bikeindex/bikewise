class BwReport < ActiveRecord::Base
  include Reportable
  #   bw -> Bikewise
  # 
  # 
  def self.id_from_external_hash(hash)
    nil
  end

  def set_attrs_from_hash
    self.external_api_updated_at = Time.now
  end

  def incident_attrs
    hash = {
      title: external_api_hash[:title],
      description: external_api_hash[:description],
      image_url: '',
      image_url_thumb: '',
      create_open311_report: external_api_hash[:create_open311_report],
      occurred_at: occurred_at,
      incident_type_id: incident_type_id,
    }
    if external_api_hash[:media].present?
      hash[:image_url] = external_api_hash[:media][:image_url]
      hash[:image_url_thumb] = external_api_hash[:media][:image_url_thumb]
    end
    if external_api_hash[:address].present?
      hash[:address] = external_api_hash[:address]
    end
    if external_api_hash[:latitude].present? && external_api_hash[:longitude].present?
      hash[:latitude] = external_api_hash[:latitude]
      hash[:longitude] = external_api_hash[:longitude]
    end
    hash
  end

  def is_open311_report
    false
  end

  def incident_type_id
    IncidentType.fuzzy_find_id(external_api_hash[:incident_type])
  end

  def source_hash
    {
      name: "Bikewise.org",
      html_url: nil,
      api_url: nil
    }
  end

  def occurred_at
    Time.at(external_api_hash[:occurred_at].to_i).utc.to_datetime
  end

  def hash_updated_at(hash)
    Time.now
  end

end
