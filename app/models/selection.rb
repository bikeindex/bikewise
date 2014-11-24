class Selection < ActiveRecord::Base
  # Attributes name, select_type, user_created

  has_many :hazard_selects, class_name: 'Hazard', foreign_key: :hazard_select_id

  has_many :locking_selects, class_name: 'Theft', foreign_key: :locking_select_id
  has_many :locking_defeat_selects, class_name: 'Theft', foreign_key: :locking_defeat_select_id

  has_many :condition_selects, class_name: 'Crash', foreign_key: :condition_select_id
  has_many :location_selects, class_name: 'Crash', foreign_key: :location_select_id
  has_many :crash_selects, class_name: 'Crash', foreign_key: :crash_select_id
  has_many :vehicle_selects, class_name: 'Crash', foreign_key: :vehicle_select_id
  
end
