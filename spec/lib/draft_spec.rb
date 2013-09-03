require 'spec_helper'

describe Draft do
  subject { Draft.new(league) }

  context "for a league without any draft picks" do
    let(:league) { FactoryGirl.build(:league) }

    its(:status) { should == :not_started}
    its(:available_teams) { should be_nil }
  end

  context "for a league with draft picks not yet selected" do
    let(:league) { FactoryGirl.create(:league) }
    let!(:draft_pick) { FactoryGirl.create(:draft_pick, league: league) }
    let!(:selected_draft_pick) { FactoryGirl.create(:draft_pick, league: league, team_id: 26) }

    its(:status) { should == :in_progress}

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
  end

  context "for a league with all draft picks selected" do
    let(:league) { FactoryGirl.create(:league) }
    let!(:draft_pick) { FactoryGirl.create(:draft_pick, league: league, team_id: 1)}

    its(:status) { should == :complete}
    its(:available_teams) { should be_nil }
  end
end
