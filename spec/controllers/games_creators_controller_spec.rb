require 'spec_helper'

describe GamesCreatorsController do
  describe "POST create" do
    def go!
      post :create, "games_creator" => {
        "week" => "1",
        "team_26" => "0",
        "team_1" => "0",
        "team_9" => "0",
        "team_23" => "0",
        "team_18" => "0",
        "team_10" => "0",
        "team_11" => "0",
        "team_27" => "0",
        "team_15" => "0",
        "team_2" => "0",
        "team_28" => "0",
        "team_6" => "0",
        "team_3" => "0",
        "team_7" => "0",
        "team_31" => "0",
        "team_32" => "0",
        "team_19" => "0",
        "team_12" => "0",
        "team_4" => "0",
        "team_20" => "0",
        "team_14" => "0",
        "team_24" => "0",
        "team_29" => "0",
        "team_30" => "1",
        "team_16" => "1",
        "team_21" => "0",
        "team_5" => "1",
        "team_8" => "0",
        "team_17" => "1",
        "team_22" => "0",
        "team_25" => "0",
        "team_13" => "0",
      }
    end

    it "creates regular season games for the winning teams" do
      expect { go! }.to change { RegularSeasonGame.count }.by(4)

      expect(RegularSeasonGame.all.map(&:winner_id)).to include(30, 16, 5, 17)
    end
  end
end
