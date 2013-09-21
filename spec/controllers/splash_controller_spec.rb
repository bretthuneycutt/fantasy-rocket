require 'spec_helper'

describe SplashController do
  context "when logged out" do
    describe "GET :index" do
      # TODO change to generic FR homepage
      it "returns NFL page on www" do
        @request.host = "www.fantasyrocket.com"

        get :index

        subject.send(:current_sport).should == :nfl
      end

      it "returns NFL page on nfl subdomain" do
        @request.host = "nfl.fantasyrocket.com"

        get :index

        subject.send(:current_sport).should == :nfl
      end

      it "returns NBA page on nba subdomain" do
        @request.host = "nba.fantasyrocket.com"

        get :index

        subject.send(:current_sport).should == :nba
      end
    end
  end

  context "when logged in as user with both nfl and nba league" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:nfl_league) { FactoryGirl.create(:nfl_league, commissioner: user) }
    let!(:nba_league) { FactoryGirl.create(:nba_league, commissioner: user) }

    before(:each) { @request.cookies[:auth_token] = user.auth_token }

    it "redirects to nfl leafue on nfl subdomain" do
      @request.host = "nfl.fantasyrocket.com"

      get :index

      response.should redirect_to(league_url(nfl_league, subdomain: :nfl))
    end

    it "redirects to nba league on nba subdomain" do
      @request.host = "nba.fantasyrocket.com"

      get :index

      response.should redirect_to(league_url(nba_league, subdomain: :nba))
    end
  end
end
