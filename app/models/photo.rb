class Photo < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
  
  mount_uploader :file_uri, PhotoUploader
end
