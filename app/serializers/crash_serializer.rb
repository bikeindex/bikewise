class CrashSerializer < ActiveModel::Serializer
  attributes :rain,
    :snow,
    :fog,
    :wind,
    :lights,
    :helmet,
    :injury_description,
    :conditions_description,
    :condition_type,
    :lighting_type,
    :visibility_type,
    :injury_severity_type,
    :location_type,
    :crash_type,
    :vehicle_type


    def condition_type
      object.condition_select.name
    end
    def lighting_type
      object.lighting_select.name
    end
    def visibility_type
      object.visibility_select.name
    end
    def injury_severity_type
      object.injury_severity_select.name
    end
    def location_type
      object.location_select.name
    end
    def crash_type
      object.crash_select.name
    end
    def vehicle_type
      object.vehicle_select.name
    end

end
