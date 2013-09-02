class User < ActiveRecord::Base
  has_secure_password

  # attr_accessible :name, :email, :password, :password_confirmation

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, email: true

  has_many :leagues, foreign_key: "commissioner_id", inverse_of: :commissioner
end
