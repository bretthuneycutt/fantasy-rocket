class Draft
  attr_reader :league

  def initialize(league)
    @league = league
  end

  def picks
    league.draft_picks
  end

  def status
    if picks.empty?
      :not_started
    elsif picks.any? { |p| !p.selected? }
      :in_progress
    else
      :complete
    end
  end

  def picked_team_ids
    @picked_ids ||= picks.map(&:team_id).compact
  end

  def available_teams
    @available_teams ||= if status == :in_progress
      Team.all.select do |team|
        !picked_team_ids.include? team.id
      end
    end
  end
end
