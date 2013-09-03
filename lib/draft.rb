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
end
