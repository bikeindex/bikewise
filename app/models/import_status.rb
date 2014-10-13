class ImportStatus < ActiveRecord::Base
  # Attributes: source, checked_updates_at, info_hash
  serialize :info_hash
  validates_presence_of :source 
  validates_uniqueness_of :source 

  before_create :set_info_hash 
  def set_info_hash
    self.info_hash = {} unless info_hash.present?
    true
  end

end
