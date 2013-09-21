require 'spec_helper'

describe NFLRegularSeasonGame do
  it_behaves_like "a FactoryGirl class"

  subject { FactoryGirl.build(:nfl_regular_season_game, winner_id: NFLTeam::ARIZONA_CARDINALS) }

  its(:winner) { subject.winner.name.should == "Arizona Cardinals"}
end

describe NBARegularSeasonGame do
  it_behaves_like "a FactoryGirl class"

  subject { FactoryGirl.build(:nba_regular_season_game, winner_id: NBATeam::PHOENIX_SUNS) }

  its(:winner) { subject.winner.name.should == "Phoenix Suns"}
end

