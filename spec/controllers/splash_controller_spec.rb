require 'spec_helper'

describe SplashController do
  describe "GET :index" do
    # TODO change to generic FR homepage
    it "returns NFL page on www" do
      @request.host = "www.fantasyrocket.com"

      get :index

      Sport.key.should == :nfl
    end

    it "returns NFL page on nfl subdomain" do
      @request.host = "nfl.fantasyrocket.com"

      get :index

      Sport.key.should == :nfl
    end

    it "returns NBA page on nba subdomain" do
      @request.host = "nba.fantasyrocket.com"

      get :index

      Sport.key.should == :nba
    end
  end
end
