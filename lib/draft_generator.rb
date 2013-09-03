require 'team'

class DraftGenerator
  attr_accessor :league, :members

  def initialize(league)
    @league = league
    # Randomize order of members
    @members = league.members.shuffle
  end

  def generate_picks!
    # TODO - implement better algorithm here to make it fair
    # Right now it is sequential
    picks = []
    members.each_with_index do |member, member_i|
      (0...picks_per_member).to_a.each do |pick_i|
        order = (member_i * picks_per_member) + pick_i
        picks << league.draft_picks.new(member: member, order: order)
      end
    end
    picks.each(&:save!)
  end

  def picks_per_member
    Team.size / members.size
  end
end
