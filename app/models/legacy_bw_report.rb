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
  end

  def incident_attrs
    occurred = external_api_hash[:crash_date] || external_api_hash[:create_date]    
    location_select_id = selection_id({type: 'location', name: external_api_hash[:location_type]})
    hash = {
      latitude: external_api_hash[:lat],
      longitude: external_api_hash[:lng],
      address: external_api_hash[:address],
      title: title_from_hash,
      description: external_api_hash[:main_desc],
      age: external_api_hash[:cyclist_age],
      country_id: Country.fuzzy_iso_find_id(external_api_hash[:country]),
      experience_level_select_id: xp_from_hash,
      gender_select_id: gender_from_hash,
      occurred_at: Time.parse(occurred),
      incident_type_id: incident_type_id,
      location_select_id: location_select_id,
      location_description: external_api_hash[:location_desc],
      user_id: user_id_from_hash
    }
  end

  def source_hash
    {
      name: "Bikewise.org",
      html_url: nil,
      api_url: nil
    }
  end

  def is_open311_report
    false
  end

  def gender_from_hash
    return nil unless external_api_hash[:cyclist_gender]
    gender = external_api_hash[:cyclist_gender]
    gender = "male" if gender.downcase.strip == 'm'
    gender = "female" if gender.downcase.strip == 'f'
    selection_id({type: 'gender', name: gender})
  end

  def xp_from_hash
    return nil unless external_api_hash[:cyclist_experience].present?
    selection_id({type: 'experience_level', name: external_api_hash[:cyclist_experience]})
  end

  def user_id_from_hash
    self.legacy_bw_user_id = external_api_hash[:create_by]
    user = User.where(legacy_bw_id: legacy_bw_user_id).first
    user.id if user.present?
  end

  def title_from_hash
    return '' unless external_api_hash[:main_desc].present?
    truncate(external_api_hash[:main_desc], length: 100).gsub(/\s/, ' ')
  end

  def geometry_from_hash
    crash_geometry[external_api_hash[:geometry]]
  end

  def incident_type_id
    IncidentType.find_or_create_by(slug: external_api_hash[:report_type]).id
  end

  def after_incident_actions
    self.send("create_#{external_api_hash[:report_type]}")
  end

  def create_crash
    self.reload
    crash_params = {
      rain: (true ? external_api_hash[:rain] == 1 : false ),
      snow: (true ? external_api_hash[:snow] == 1 : false ),
      fog: (true ? external_api_hash[:fog] == 1 : false ),
      wind: (true ? external_api_hash[:wind] == 1 : false ),
      lights: (true ? external_api_hash[:lights] == 1 : false ),
      helmet: (true ? external_api_hash[:helmet] == 1 : false ),
      conditions_description: external_api_hash[:conditions_desc],
      injury_description: external_api_hash[:injury_desc]
    }
    [
      {type: 'lighting', name: external_api_hash[:lighting]},
      {type: 'visibility', name: external_api_hash[:visibility]},
      {type: 'injury_severity', name: external_api_hash[:injury_severity]},
      {type: 'condition', name: external_api_hash[:road_conditions]},
      {type: 'geometry', name: geometry_from_hash, alt: external_api_hash[:geometry_other]},
      {type: 'crash', name: external_api_hash[:crash_type], alt: external_api_hash[:crash_type_other] },
      {type: 'vehicle', name: external_api_hash[:vehicle_type]}
    ].each do |select|
      crash_params.merge!({ "#{select[:type]}_select_id" => selection_id(select) })
    end
    crash = Crash.create(crash_params)
    incident.type_properties = crash
    incident.save
  end

  def create_hazard
    self.reload
    h_select = {type: 'hazard', name: external_api_hash[:hazard_type], alt: external_api_hash[:hazard_type_other]}
    p_select = {type: 'priority', name: external_api_hash[:priority]}
    hazard_params = {
      hazard_select_id: selection_id(h_select),
      priority_select_id: selection_id(p_select)
    }
    hazard = Hazard.create(hazard_params)
    incident.type_properties = hazard
    incident.save
  end

  def selection_id(params)
    select = {
      select_type: params[:type],
      name: params[:name],
      user_created: false
    }
    select.merge!({user_created: true, name: params[:alt_name]}) if params[:alt_name].present?
    return nil unless select[:name].present?
    Selection.fuzzy_find_or_create(select).id
  end

  def crash_geometry
    file = File.join(Rails.root,'public', 'legacy_bw_geometry.json')
    JSON.parse(File.read(file))
  end

  def hash_updated_at(hash)
    external_api_hash[:edit_date] || external_api_hash[:create_date]
  end

end
