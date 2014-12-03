class Country < ActiveRecord::Base
  # Attributes: name, iso

  validates_presence_of :name, :iso
  validates_uniqueness_of :name, :iso
  has_many :incidents

  def self.fuzzy_iso_find_id(n)
    return nil unless n.present?
    n = 'us' if n.match(/(usa)|(united.s)/i)
    c = self.where("lower(iso) = ?", n.downcase.strip).first
    return c.id if c.present?
    nil
  end

end
