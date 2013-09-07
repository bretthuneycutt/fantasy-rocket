class User < ActiveRecord::Base
  has_secure_password

  # attr_accessible :name, :email, :password, :password_confirmation

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, email: true

  validates :auth_token, presence: true, uniqueness: true

  has_many :commissioned_leagues, class_name: "League", foreign_key: "commissioner_id", inverse_of: :commissioner

  has_many :league_memberships, foreign_key: "member_id"
  has_many :leagues, through: :league_memberships
  has_many :draft_picks, foreign_key: "member_id", inverse_of: :member

  before_create -> { self.email = email.andand.downcase }

  before_create { generate_token(:auth_token) }

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
end
