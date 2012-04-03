class Song < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
  
  mount_uploader :album_cover, CoverUploader
end
