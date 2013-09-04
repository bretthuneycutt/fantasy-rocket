class User < ActiveRecord::Base
  has_secure_password

  # attr_accessible :name, :email, :password, :password_confirmation

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, email: true

  has_many :commissioned_leagues, class_name: "League", foreign_key: "commissioner_id", inverse_of: :commissioner

  has_many :league_memberships, foreign_key: "member_id"
  has_many :leagues, through: :league_memberships
  has_many :draft_picks, foreign_key: "member_id", inverse_of: :member

  before_create -> { self.email = email.andand.downcase }

end
