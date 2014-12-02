# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include ::CarrierWave::Backgrounder::Delay
  include CarrierWave::MiniMagick
 
  if Rails.env.test?
    storage :file
  elsif Rails.env.development?
    storage :file
  else
    storage :fog
  end
  
  after :remove, :delete_empty_upstream_dirs  
  def delete_empty_upstream_dirs
    path = ::File.expand_path(store_dir, root)
    Dir.delete(path) # fails if path not empty dir
    
    path = ::File.expand_path(base_store_dir, root)
    Dir.delete(path) # fails if path not empty dir
  rescue SystemCallError
    true # nothing, the dir is not empty
  end

  def store_dir
    "#{base_store_dir}/#{model.id}"
  end
  
  def base_store_dir
    "uploads"
  end

  def extension_white_list
    %w(jpg jpeg gif png tiff tif)
  end

  process :fix_exif_rotation

  version :large do
    process resize_to_fit: [1200, 900]
  end

  version :small, from_version: :large do
    process resize_to_fill: [100,100]
  end

end
