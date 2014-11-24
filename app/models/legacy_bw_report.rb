class LegacyBwReport < ActiveRecord::Base
  include Reportable
  include ActionView::Helpers::TextHelper
  #   bw -> Bikewise
  #   This is data imported from the old site
  # 

  def self.id_from_external_hash(hash)
    "#{hash[:report_type]}#{hash[:id]}"
  end

  def set_attrs_from_hash
    date = external_api_hash[:edit_date] || external_api_hash[:create_date]
    self.external_api_updated_at = Time.parse(date)
    self.legacy_bw_user_id = external_api_hash[:create_by]
  end

  def incident_attrs
    type = external_api_hash[:report_type]
    it_id = IncidentType.fuzzy_find_id(type) || IncidentType.find_or_create_by(slug: type).id
    hash = {
      latitude: external_api_hash[:lat],
      longitude: external_api_hash[:lng],
      address: external_api_hash[:address],
      title: truncate(external_api_hash[:address], length: 200),
      description: external_api_hash[:main_description],
      incident_type_id: it_id
    }
  end

  def source_hash
    {
      name: "Bikewise.org",
      html_url: nil,
      api_url: nil
    }
  end

  def create_crash
    
  end


end
