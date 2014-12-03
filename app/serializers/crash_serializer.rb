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
    :crash_type,
    :vehicle_type


    def condition_type
      object.condition_select.name if object.condition_select
    end
    def lighting_type
      object.lighting_select.name if object.lighting_select
    end
    def visibility_type
      object.visibility_select.name if object.visibility_select
    end
    def injury_severity_type
      object.injury_severity_select.name if object.injury_severity_select
    end
    def crash_type
      object.crash_select.name if object.crash_select
    end
    def vehicle_type
      object.vehicle_select.name if object.vehicle_select
    end

end
