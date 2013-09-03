require 'spec_helper'

describe Draft do
  subject { Draft.new(league) }

  context "for a league without any draft picks" do
    let(:league) { FactoryGirl.build(:league) }

    its(:status) { should == :not_started}
  end

  context "for a league with draft picks not yet selected" do
    let(:league) { FactoryGirl.create(:league) }
    let!(:draft_pick) { FactoryGirl.create(:draft_pick, league: league)}

    its(:status) { should == :in_progress}
  end

  context "for a league with all draft picks selected" do
    let(:league) { FactoryGirl.create(:league) }
    let!(:draft_pick) { FactoryGirl.create(:draft_pick, league: league, team_id: 1)}

    its(:status) { should == :complete}
  end
end
