class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :nickname, :bio, :avatar_url, :html_url
  
  before_create :ensure_authentication_token
  
  has_many :lists
  has_many :items
  has_many :list_users
  has_many :songs
  has_many :photos
  has_many :voices
  
  mount_uploader :avatar_url, AvatarUploader
end
