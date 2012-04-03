class List < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  
  has_many :items
  has_many :list_users
  has_one :category
  
  # callbacks
  before_create :set_user_properties
  
  protected
    def set_user_properties
      self.name = self.user.name
      self.nickname = self.user.nickname
      self.avatar_url = self.user.avatar_url
    end
end
