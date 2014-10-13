class Country < ActiveRecord::Base
  # Attributes: name, iso

  validates_presence_of :name, :iso
  validates_uniqueness_of :name, :iso

end
