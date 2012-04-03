# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick
  
  storage :grid_fs

  def filename
    model.salt ||= SecureRandom.hex
    "#{model.salt}#{File.extname(original_filename).downcase}" if original_filename
  end

end
