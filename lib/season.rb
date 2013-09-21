class Season
  attr_reader :league
  delegate :team_class, to: :league

  def initialize(league)
    @league = league
  end

  def started?
    team_class.win_counts.values.any?{ |v| v > 0 }
  end
end
