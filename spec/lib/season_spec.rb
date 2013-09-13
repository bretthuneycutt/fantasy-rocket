require 'spec_helper'

describe Season do
  describe '.started?' do
    it "is false if a win hasn't been registered" do
      Season.should_not be_started
    end

    it "is true if a win has been registered" do
      FactoryGirl.create(:regular_season_game)

      Season.should be_started
    end
  end
end
