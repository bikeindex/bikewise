class Selection < ActiveRecord::Base
  # Attributes name, select_type, user_created

  validates_uniqueness_of :name, scope: [:select_type]

  has_many :hazard_selects, class_name: 'Hazard', foreign_key: :hazard_select_id
  has_many :hazard_priority_selects, class_name: 'Hazard', foreign_key: :priority_select_id

  has_many :locking_selects, class_name: 'Theft', foreign_key: :locking_select_id
  has_many :locking_defeat_selects, class_name: 'Theft', foreign_key: :locking_defeat_select_id

  has_many :condition_selects, class_name: 'Crash', foreign_key: :condition_select_id
  has_many :crash_selects, class_name: 'Crash', foreign_key: :crash_select_id
  has_many :vehicle_selects, class_name: 'Crash', foreign_key: :vehicle_select_id
  has_many :geometry_selects, class_name: 'Crash', foreign_key: :geometry_select_id

  has_many :lighting_selects, class_name: 'Crash', foreign_key: :lighting_select_id
  has_many :visibility_selects, class_name: 'Crash', foreign_key: :visibility_select_id
  has_many :injury_severity_selects, class_name: 'Crash', foreign_key: :injury_severity_select_id

  has_many :incident_location_selects, class_name: 'Incident', foreign_key: :location_select_id
  has_many :incident_experience_level_selects, class_name: 'Incident', foreign_key: :experience_level_select_id
  has_many :incident_gender_selects, class_name: 'Incident', foreign_key: :experience_level_select_id

  has_many :user_experience_level_selects, class_name: 'User', foreign_key: :experience_level_select_id
  has_many :user_gender_selects, class_name: 'User', foreign_key: :experience_level_select_id

  scope :default, -> { where(user_created: false) }
  scope :user_created, -> { where(user_created: true) }

  scope :hazard, -> { where(select_type: 'hazard') }
  scope :locking, -> { where(select_type: 'locking') }
  scope :locking_defeat, -> { where(select_type: 'locking_defeat') }
  scope :condition, -> { where(select_type: 'condition') }
  scope :location, -> { where(select_type: 'location') }
  scope :crash, -> { where(select_type: 'crash') }
  scope :vehicle, -> { where(select_type: 'vehicle') }
  scope :lighting, -> { where(select_type: 'lighting') }
  scope :visibility, -> { where(select_type: 'visibility') }
  scope :injury_severity, -> { where(select_type: 'injury_severity') }
  scope :experience_level, -> { where(select_type: 'experience_level') }
  scope :gender, -> { where(select_type: 'gender') }

  def self.possible_types
    self.all.pluck(:select_type).uniq
  end

  def self.fuzzy_find_or_create(h)
    hash = ActiveSupport::HashWithIndifferentAccess.new(h)
    select_hash = {
      select_type: hash[:select_type].downcase.strip.gsub(/\s+/,'_'),
      name: hash[:name].downcase.strip.gsub(/\s+/, ' '),
      user_created: hash[:user_created]
    }
    Selection.find_or_create_by(select_hash)
  end
      
end
