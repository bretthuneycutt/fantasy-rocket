class User < ActiveRecord::Base
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, email: true

  # validates :auth_token, presence: true, uniqueness: true

  has_many :commissioned_leagues, class_name: "League", foreign_key: "commissioner_id", inverse_of: :commissioner

  has_many :league_memberships, foreign_key: "member_id"
  has_many :leagues, through: :league_memberships
  has_many :draft_picks, foreign_key: "member_id", inverse_of: :member

  has_one :subscription, -> { where(:canceled_at => nil) }
  has_one :canceled_subscription, -> { where('canceled_at IS NOT NULL').order('canceled_at DESC') }, class_name: "Subscription"

  before_create -> { self.email = email.downcase.strip  if email }

  before_create { generate_token(:auth_token) }

  def subscriber?
    !!subscription or (canceled_subscription && !canceled_subscription.expired?)
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  # helps combine user accounts (common if someone mistypes email address)
  # TODO remove when we add proper email validation and confirmation
  def assimilate_user!(user)
    League.where(commissioner_id: user.id).each do |l|
      l.update_attributes!(commissioner_id: id)
    end
    LeagueMembership.where(member_id: user.id).each do |lm|
      begin
        lm.update_attributes!(member_id: id)
      rescue ActiveRecord::RecordInvalid
        lm.destroy!
      end
    end
    DraftPick.where(member_id: user.id).each do |lm|
      lm.update_attributes!(member_id: id)
    end
    user.destroy!
  end
end
