require 'spec_helper'

describe "splash/index" do
  context "when Sport is NFL" do
    before(:each) { view.stub(:current_sport) { :nfl } }

    it "renders NFL copy" do
      render

      rendered.should include "Home of the NFL Wins Pool"
    end
  end

  context "when Sport is NBA" do
    before(:each) { view.stub(:current_sport) { :nba } }

    it "renders NBA copy" do
      render

      rendered.should include "Home of the NBA Wins Pool"
    end
  end
end
