class NBARegularSeasonGame < RegularSeasonGame
  validates :winner_id, presence: true, inclusion: { in: 1..NBATeam::TOTAL_NUMBER, message: "must be one of 30 NBA teams"}, uniqueness: { scope: :week, message: "should win only once per week" }

  def team_class
    NBATeam
  end
end
