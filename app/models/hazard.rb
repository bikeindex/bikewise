class Hazard < ActiveRecord::Base
  include IncidentTypeable
  # Attributes :hazard_select_id, :priority_select_id
  belongs_to :hazard_select, class_name: "Selection"
  belongs_to :priority_select, class_name: "Selection"

end
