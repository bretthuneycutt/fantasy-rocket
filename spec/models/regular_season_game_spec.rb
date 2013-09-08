require 'spec_helper'

describe RegularSeasonGame do
  it_behaves_like "a FactoryGirl class"

  subject { FactoryGirl.build(:regular_season_game, winner_id: Team::ARIZONA_CARDINALS)}

  describe "#winner" do
    it "is the AZ Cardinals" do
      subject.winner.name.should == "Arizona Cardinals"
    end
  end
end
