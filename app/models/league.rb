require 'draft'

class League < ActiveRecord::Base
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
    "hmac_key"
  end

private

  def add_commissioner_as_member
    members << commissioner
  end
end
