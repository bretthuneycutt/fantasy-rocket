require 'team'

class DraftGenerator
  attr_accessor :league, :members

  def initialize(league)
    @league = league
    # Randomize order of members
    @members = league.members.shuffle
  end

  def generate_picks!
    return  unless @league.draft.ready_to_start?

    DRAFT_POSITIONS_BY_LEAGUE_SIZE[members.size].each_with_index do |member_index, position|
      league.draft_picks.create!(member: members[member_index], order: position)
    end
  end

  DRAFT_POSITIONS_BY_LEAGUE_SIZE = {
    2 => [0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,],
    3 => [0,1,2,2,1,0,0,1,2,2,1,0,0,1,2,2,1,0,0,1,2,2,1,0,0,1,2,2,1,0,],
    4 => [0,1,2,3,3,2,1,0,0,1,2,3,3,2,1,0,0,1,2,3,3,2,1,0,0,1,2,3,3,2,1,0,],
    5 => [0,1,2,3,4,4,3,2,1,0,0,1,2,3,4,4,3,2,1,0,0,1,2,3,4,4,3,2,1,0,],
    6 => [0,1,2,3,4,5,5,4,3,2,1,0,0,1,2,3,4,5,4,1,3,5,2,0,5,2,0,3,4,1,],
    7 => [0,1,2,3,4,5,6,6,5,4,3,2,1,0,0,1,2,3,4,5,6,6,5,4,3,2,1,0,],
    8 => [0,1,2,3,4,5,6,7,7,6,5,4,3,2,1,0,0,1,2,3,4,5,6,7,7,6,5,4,3,2,1,0,],
    9 => [0,1,2,3,4,5,6,7,8,5,8,2,4,7,1,6,3,0,6,7,3,8,0,4,1,5,2,],
    10 => [0,1,2,3,4,5,6,7,8,9,6,9,2,8,4,1,7,3,5,0,7,5,8,9,3,0,4,6,1,2,],
    11 => [0,1,2,3,4,5,6,7,8,9,10,10,9,8,7,6,5,4,3,2,1,0,],
    12 => [0,1,2,3,4,5,6,7,8,9,10,11,11,10,9,8,7,6,5,4,3,2,1,0,],
    13 => [0,1,2,3,4,5,6,7,8,9,10,11,12,12,11,10,9,8,7,6,5,4,3,2,1,0,],
    14 => [0,1,2,3,4,5,6,7,8,9,10,11,12,13,13,12,11,10,9,8,7,6,5,4,3,2,1,0,],
    15 => [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,],
    16 => [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,],
  }
end
