require 'spec_helper'

describe RegularSeasonGamesController do
  before :each do
    FactoryGirl.create(:regular_season_game, winner_id: NFLTeam::ARIZONA_CARDINALS)
    FactoryGirl.create(:regular_season_game, winner_id: NFLTeam::DENVER_BRONCOS)
  end

  describe "GET 'index'" do
    it "renders correctly" do
      get :index

      response.should render_template(:index)
    end
  end
end
