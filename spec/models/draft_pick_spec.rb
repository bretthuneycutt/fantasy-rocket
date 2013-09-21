require 'spec_helper'

shared_examples "a draft pick with selected team" do |team_name|
  its(:selected?) { should be_true }
  its(:team) { should be_a Team}
end

describe DraftPick do
  it_behaves_like "a FactoryGirl class"

  subject { FactoryGirl.build(:draft_pick, order: 20) }

  its(:as_ordinal) { should == "21st" }

  context "with team not yet selected" do
    subject { FactoryGirl.build(:draft_pick) }

    its(:selected?) { should be_false }
    its(:team) { should be_nil }
  end

  context "with selected NBA team" do
    subject { FactoryGirl.build(:nba_draft_pick, team_id: 26) }

    it_behaves_like "a draft pick with selected team"
    its(:team) { subject.team.name.should == "New Orleans Pelicans" }
  end

  context "with selected NFL team" do
    subject { FactoryGirl.build(:nfl_draft_pick, team_id: 26) }

    it_behaves_like "a draft pick with selected team"
    its(:team) { subject.team.name.should == "Arizona Cardinals" }
  end
end
