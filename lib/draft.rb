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
    return  unless status == :in_progress

    @available_teams ||= Team.all.select do |team|
        !picked_team_ids.include? team.id
    end
  end

  def current_pick
    return  unless status == :in_progress

    @current_picker ||= picks.where(:team_id => nil).first
  end

  def current_picker
    return  unless status == :in_progress

    current_pick.member
  end
end
