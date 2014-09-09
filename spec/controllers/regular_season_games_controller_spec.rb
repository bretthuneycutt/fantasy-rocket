require 'spec_helper'

describe RegularSeasonGamesController do
  render_views

  before :each do
    FactoryGirl.create(:regular_season_game, winner_id: NFLTeam::ARIZONA_CARDINALS)
    FactoryGirl.create(:regular_season_game, winner_id: NFLTeam::DENVER_BRONCOS)
    FactoryGirl.create(:nba_regular_season_game, winner_id: NBATeam::PHOENIX_SUNS)
  end

  describe "GET 'index' for nfl" do
    it "renders correctly" do
      get :index

      response.should render_template(:index)
      response.body.should include("Arizona Cardinals", "Denver Broncos")
      response.body.should_not include("Phoenix Suns")
    end
  end

  describe "GET 'index' for nba" do
    it "renders correctly" do
      subject.stub(:current_sport) { :nba }

      get :index

      response.should render_template(:index)
      response.body.should_not include("Arizona Cardinals", "Denver Broncos")
      response.body.should include("Phoenix Suns")
    end
  end
end
