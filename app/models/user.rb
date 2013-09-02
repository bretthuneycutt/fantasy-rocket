class User < ActiveRecord::Base
  has_secure_password

  # attr_accessible :name, :email, :password, :password_confirmation

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, email: true
end
