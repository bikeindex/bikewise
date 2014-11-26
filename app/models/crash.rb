class Crash < ActiveRecord::Base
  include IncidentTypeable
  # Attributes :rain, :snow, :fog, :wind, :lights, :helmet, condition_select_id
  #            :lighting_select_id, :visibility_select_id, :conditions_description,
  #            :injury_severity_select_id, :injury_description, 
  #            :location_select_id :crash_select_id, :vehicle_select_id

    belongs_to :condition_select, class_name: "Selection"
    belongs_to :location_select, class_name: "Selection"
    belongs_to :crash_select, class_name: "Selection"
    belongs_to :geometry_select, class_name: "Selection"
    belongs_to :vehicle_select, class_name: "Selection"
    belongs_to :lighting_select, class_name: "Selection"
    belongs_to :visibility_select, class_name: "Selection"
    belongs_to :injury_severity_select, class_name: "Selection"

end