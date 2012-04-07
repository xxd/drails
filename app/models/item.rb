class Item < ActiveRecord::Base
  belongs_to :user
  belongs_to :list

  has_many :songs
  has_many :photos
  has_many :voices
  
  # callbacks
  before_create :set_user_properties
  
  protected
    def set_user_properties
      self.nickname = self.user.nickname
      self.avatar_url = self.user.avatar_url
    end
end
