class CrashesSerializer < ActiveModel::Serializer
  attributes :rain,
    :snow,
    :fog,
    :wind,
    :lights,
    :helmet,
    :condition_select_id,
    :lighting_select_id,
    :visibility_select_id,
    :conditions_description,
    :injury_severity_select_id,
    :injury_description,
    :location_select_id,
    :crash_select_id,
    :vehicle_select_id


end
