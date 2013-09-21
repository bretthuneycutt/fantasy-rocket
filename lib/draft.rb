class Draft
  attr_reader :league
  delegate :team_class, to: :league

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

  def ready_to_start?
    status == :not_started && league.members.count > 1
  end

  def picked_team_ids
    @picked_ids ||= picks.map(&:team_id).compact
  end

  def unavailable_teams
    return  unless status == :in_progress

    @unavailable_teams ||= team_class.all - available_teams
  end

  def available_teams
    return  unless status == :in_progress

    @available_teams ||= team_class.all.select do |team|
      !picked_team_ids.include? team.id
    end
  end

  def last_pick
    return  unless status == :in_progress

    @last_pick ||= picks.where('team_id IS NOT NULL').last
  end

  def last_picker
    return  unless status == :in_progress

    last_pick.member
  end

  def current_pick
    return  unless status == :in_progress

    @current_pick ||= picks.where(:team_id => nil).first
  end

  def current_picker
    return  unless status == :in_progress

    current_pick.member
  end
end
