class NFLRegularSeasonGame < RegularSeasonGame
  validates :winner_id, presence: true, inclusion: { in: 1..32, message: "must be one of 32 NFL teams"}, uniqueness: { scope: :week, message: "should win only once per week" }

  def team_class
    NFLTeam
  end
end
