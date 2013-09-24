class LeagueMembership < ActiveRecord::Base
  belongs_to :member, class_name: "User"
  belongs_to :league

  validates :member_id, presence: true, uniqueness: { scope: :league_id, message: "should only join league once" }
  validates :league_id, presence: true

  def default_tweet
    "I joined #{league.name} #winspool"
  end
end
