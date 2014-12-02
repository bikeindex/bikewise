class Image < ActiveRecord::Base
  # Attributes :image, :name, :incident_id

  belongs_to :incident
  mount_uploader :image, ImageUploader

  before_create :default_name
  def default_name
    self.name ||= File.basename(image.filename, '.*').titleize if image
  end


end