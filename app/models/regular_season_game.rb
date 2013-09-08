class RegularSeasonGame < ActiveRecord::Base
  validates :winner_id, presence: true, inclusion: { in: 1..32, message: "must be one of 32 NFL teams"}, uniqueness: { scope: :week, message: "should win only once per week" }
  validates :week, presence: true, inclusion: { in: 1..17, message: "should span 1 to 17"}

  def winner
    Team.find_by_id(winner_id)
  end
end
