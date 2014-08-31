require 'draft'

class League < ActiveRecord::Base
  MEMBER_LIMIT = 15

  validates :name, presence: true
  validates :commissioner_id, presence: true
  validates :sport, presence: true

  belongs_to :commissioner, class_name: "User", inverse_of: :commissioned_leagues

  has_many :league_memberships

  has_many :members, through: :league_memberships, class_name: "User"

  has_many :draft_picks, -> { order('draft_picks.order') }, inverse_of: :league

  after_create :add_commissioner_as_member

  scope :draft_complete, -> { where('draft_completed_at IS NOT NULL') }

  default_scope { where(season: ENV['CURRENT_SEASON']) }
  validates :season, presence: true
  before_validation :set_season

  has_one :next, class_name: "League", foreign_key: "previous_id", inverse_of: :previous
  belongs_to :previous, class_name: "League", inverse_of: :next

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

  def sport
    read_attribute(:sport).andand.to_sym
  end
  alias_method :subdomain, :sport

  def team_class
    case sport
    when :nba
      NBATeam
    else
      NFLTeam
    end
  end

  def default_tweet(user)
    standing = standings.detect { |s| s.member == user }
    "I'm #{standing.rank.ordinalize} in my #{I18n.t "#{sport}.league"} wins pool"
  end

  def season_started?
    team_class.win_counts.values.any?{ |v| v > 0 }
  end
private

  def add_commissioner_as_member
    add_member commissioner
  end

  def set_season
    self.season ||= ENV['CURRENT_SEASON']
  end
end
