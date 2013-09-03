require 'spec_helper'

describe DraftPick do
  it_behaves_like "a FactoryGirl class"

  context "with team not yet selected" do
    subject { FactoryGirl.build(:draft_pick) }

    its(:selected?) { should be_false }
  end

  context "with selected team" do
    subject { FactoryGirl.build(:draft_pick, :team_id => 1) }

    its(:selected?) { should be_true }
  end
end
