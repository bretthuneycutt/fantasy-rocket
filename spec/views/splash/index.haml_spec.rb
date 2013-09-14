require 'spec_helper'

describe "splash/index" do
  context "when Sport is NFL" do
    before(:each) { Sport.key = :nfl }

    it "renders NFL copy" do
      render

      rendered.should include "Home of the NFL Wins Pool"
    end
  end

  context "when Sport is NBA" do
    before(:each) { Sport.key = :nba }

    it "renders NBA copy" do
      render

      rendered.should include "Home of the NBA Wins Pool"
    end
  end
end
