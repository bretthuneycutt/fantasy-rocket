require 'spec_helper'

describe Draft do
  subject { Draft.new(league) }

  context "for a league without any draft picks" do
    let(:league) { FactoryGirl.build(:league) }

    its(:status) { should == :not_started }
    its(:available_teams) { should be_nil }
    its(:current_pick) { should be_nil }

    context "with only one member" do
      its(:ready_to_start?) { should be_false }
    end

    context "with multiple members" do
      before :each do
        league.save!
        league.members << FactoryGirl.create(:user)
      end

      its(:ready_to_start?) { should be_true }
    end
  end

  context "for a league with draft picks not yet selected" do
    let(:league) { FactoryGirl.create(:league) }

    let(:commissioner) { league.commissioner }
    let(:other_member) { FactoryGirl.create(:user) }

    let!(:pick4) { FactoryGirl.create(:draft_pick, league: league, member: other_member, order: 4) }
    let!(:pick1) { FactoryGirl.create(:draft_pick, league: league, member: commissioner, order: 1, team_id: 26) }
    let!(:pick2) { FactoryGirl.create(:draft_pick, league: league, member: other_member, order: 2) }
    let!(:pick3) { FactoryGirl.create(:draft_pick, league: league, member: commissioner, order: 3) }

    its(:status) { should == :in_progress}
    its(:ready_to_start?) { should be_false }

    describe "#available_teams" do
      it "returns all teams not selected" do
        subject.available_teams.size.should == 31
        subject.available_teams.each do |t|
          t.should be_a Team
        end
        subject.available_teams.map(&:name).should_not include "Arizona Cardinals"
        subject.available_teams.map(&:name).should include "New England Patriots", "Baltimore Ravens"
      end
    end

    describe "#unavailable_teams" do
      it "returns all selected teams" do
        subject.unavailable_teams.size.should == 1
        subject.unavailable_teams.first.name.should == "Arizona Cardinals"
      end
    end

    its(:current_pick) { should == pick2 }
  end

  context "for a league with all draft picks selected" do
    let(:league) { FactoryGirl.create(:league) }
    let!(:draft_pick) { FactoryGirl.create(:draft_pick, league: league, team_id: 1)}

    its(:status) { should == :complete}
    its(:available_teams) { should be_nil }
    its(:current_pick) { should be_nil }
    its(:ready_to_start?) { should be_false }
  end
end
