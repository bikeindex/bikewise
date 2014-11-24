class Theft < ActiveRecord::Base
  include IncidentTypeable
  # Attributes :locking_select_id, :locking_defeat_select_id,
  #            :has_police_report

  belongs_to :locking_select, class_name: "Selection"
  belongs_to :locking_defeat_select, class_name: "Selection"
  
end
