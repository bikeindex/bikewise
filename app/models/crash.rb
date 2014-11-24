class Crash < ActiveRecord::Base
  include IncidentTypeable
  # Attributes :rain, :snow, :fog, :wind, :lights, :helmet, condition_select_id
  #            :lighting, :visibility, :conditions_description,
  #            :injury_severity, :injury_description, 
  #            :location_select_id :crash_select_id, :vehicle_select_id

    # t.string :location_select_id
    # t.boolean :rain
    # t.boolean :snow
    # t.boolean :fog
    # t.boolean :wind
    # t.boolean :lights
    # t.boolean :helmet
    # t.integer :lighting
    # t.integer :visibility
    # t.text :conditions_description
    # t.integer :injury_severity
    # t.text :injury_description
    # t.string :crash_select_id
    # t.string :vehicle_select_id

    belongs_to :condition_select, class_name: "Selection"
    belongs_to :location_select, class_name: "Selection"
    belongs_to :crash_select, class_name: "Selection"
    belongs_to :vehicle_select, class_name: "Selection"

end