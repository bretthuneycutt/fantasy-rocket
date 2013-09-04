require 'spec_helper'

describe DraftPick do
  it_behaves_like "a FactoryGirl class"

  subject { FactoryGirl.build(:draft_pick, order: 20) }

  its(:as_ordinal) { should == "21st" }

  context "with team not yet selected" do
    subject { FactoryGirl.build(:draft_pick) }

    its(:selected?) { should be_false }
    its(:team) { should be_nil }
  end

  context "with selected team" do
    subject { FactoryGirl.build(:draft_pick, team_id: 26) }

    its(:selected?) { should be_true }

    describe "#team" do
      it "is AZ Cardinals" do
        subject.team.should be_a Team
        subject.team.name.should == "Arizona Cardinals"
      end
    end
  end
end
