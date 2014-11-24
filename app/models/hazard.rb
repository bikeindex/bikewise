class Hazard < ActiveRecord::Base
  include IncidentTypeable
  # Attributes :location_description, :hazard_select_id, :priority
  belongs_to :hazard_select, class_name: "Selection"

end
