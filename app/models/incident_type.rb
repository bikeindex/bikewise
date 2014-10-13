class IncidentType < ActiveRecord::Base
  # Attributes name
  # validates_presence_of :name
  validates_presence_of :slug
  validates_uniqueness_of :slug
  has_many :incidents

  before_validation :slugify
  def slugify
    self.slug = Slugifyer.slugify(name) unless slug.present?
  end

  def self.fuzzy_find_id(n)
    if !n.blank?
      n = Slugifyer.slugify(n)
      self.where(slug: n).pluck(:id).first
    else
      nil
    end
  end

end
