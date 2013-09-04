require 'draft'

class League < ActiveRecord::Base
  MEMBER_LIMIT = 15

  validates :name, presence: true
  validates :commissioner_id, presence: true

  belongs_to :commissioner, class_name: "User", inverse_of: :commissioned_leagues

  has_many :league_memberships

  has_many :members, through: :league_memberships, class_name: "User"

  has_many :draft_picks, inverse_of: :league, order: 'draft_picks.order'

  after_create :add_commissioner_as_member

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

  def team_names(user)
    picks = draft_picks.where(member: user).where('team_id IS NOT NULL')
    return unless picks.size > 0

    picks.map { |pick| pick.team.name }.sort.to_sentence
  end

private

  def add_commissioner_as_member
    add_member commissioner
  end
end
