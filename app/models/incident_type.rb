class IncidentType < ActiveRecord::Base
  # Attributes name
  validates_presence_of :name
  validates_presence_of :slug
  validates_uniqueness_of :slug
  has_many :incidents

  before_validation :slugify
  def slugify
    self.slug = Slugifyer.slugify(name)
  end

end
