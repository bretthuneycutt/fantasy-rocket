class Standing
  attr_reader :league, :member

  def initialize(league, member)
    @league = league
    @member = member
  end

  def rank
    return @rank  if @rank

    index = league.standings.index(self)
    previous = league.standings[index - 1]  if index > 0

    @rank = previous.rank  if previous.andand.win_count == win_count
    @rank ||= index + 1
  end

  def win_count
    @win_count ||= picks.inject(0) do |win_count, p|
      win_count += p.team.win_count
    end
  end

  def member_name
    member.name
  end

  def teams_and_results
    picks.map do |pick|
      team = pick.team
      "#{team.name} (#{pick.as_ordinal}, #{team.win_count})"
    end.to_sentence
  end

private

  def picks
    # TODO memoize
    league.draft_picks.picked.where(member: member)
  end

  def ==(other)
    league == other.league && member == other.member
  end
end
