require 'draft'

class League < ActiveRecord::Base
  MEMBER_LIMIT = 15

  validates :name, presence: true
  validates :commissioner_id, presence: true

  validate :valid_type?

  belongs_to :commissioner, class_name: "User", inverse_of: :commissioned_leagues

  has_many :league_memberships

  has_many :members, through: :league_memberships, class_name: "User"

  has_many :draft_picks, inverse_of: :league, order: 'draft_picks.order'

  after_create :add_commissioner_as_member

  scope :draft_complete, -> { where('draft_completed_at IS NOT NULL') }

  def draft
    @draft = Draft.new(self)
  end

  def hmac
    HMAC.id(id.to_s)
  end

  def eligible_to_be_member?(user)
    members.count < MEMBER_LIMIT && !members.include?(user)
  end

  def add_member(user)
    return  unless eligible_to_be_member?(user)
    members << user
  end

  def standings
    @standings ||= members.map { |m| Standing.new(self, m) }.sort_by(&:win_count).reverse
  end

private

  def add_commissioner_as_member
    add_member commissioner
  end

  def valid_type?
    false
  end
end
