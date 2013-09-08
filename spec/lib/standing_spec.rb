require 'spec_helper'

describe Standing do
  let!(:league) { FactoryGirl.create(:league) }
  let!(:member) do
    u = FactoryGirl.create(:user)
    league.members << u
    u
  end
  subject { Standing.new(league, member) }

  its(:league) { should == league }
  its(:member) { should == member }

  context "for uncompleted draft" do
    its(:rank) { should == 1 }
    its(:win_count) { should == 0 }
    its(:teams_and_results) { should be_empty }

    it "all ranks are equal" do
      ranks = league.standings.map(&:rank)
      ranks.each { |r| r.should == ranks[0] }
    end
  end

  context "for complete draft" do
    before :each do
      DraftGenerator.new(league).generate_picks!

      winner_id = nil

      league.draft_picks.each_with_index do |pick, i|
        i += 1
        pick.update_attribute(:team_id, i)
        winner_id ||= i  if pick.member == league.commissioner
      end

      FactoryGirl.create(:regular_season_game, winner_id: winner_id)
    end

    it "all ranks are different" do
      ranks = league.standings.map(&:rank)
      ranks[0].should_not == ranks[1]
    end

    context "for member with 1 win (commissioner)" do
      subject { Standing.new(league, league.commissioner) }

      its(:member) { should == league.commissioner }
      its(:rank) { should == 1 }
      its(:win_count) { should == 1 }
      its(:teams_and_results) { should include ", 1)" }
    end

    context "for member with 0 wins" do
      subject { Standing.new(league, member) }

      its(:member) { should_not == league.commissioner }
      its(:rank) { should == 2 }
      its(:win_count) { should == 0 }
      its(:teams_and_results) { should_not include ", 1)" }
    end
  end
end
