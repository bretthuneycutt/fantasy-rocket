require 'spec_helper'

describe DraftGenerator do
  let(:league) do
    members = []
    league = FactoryGirl.create(:league)
    # commissioner + 9 others
    9.times do
      league.members << FactoryGirl.create(:user)
    end
    league
  end

  subject { described_class.new(league) }

  its(:picks_per_member) { should == 3 }

  describe "#generate_picks!" do
    it "creates the right number of DraftPicks" do
      expect { subject.generate_picks! }.to change { DraftPick.count }.by(30)
    end

    it "assigns each member the same number of picks" do
      subject.generate_picks!
      league.members.each do |member|
        member.draft_picks.size.should == 3
      end
    end

    it "does not contain duplicate pick numbers" do
      subject.generate_picks!
      pick_numbers = league.draft_picks.map(&:order)
      pick_numbers.should == pick_numbers.uniq
      pick_numbers.should == (0..29).to_a
    end
  end
end
