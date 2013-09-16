require 'spec_helper'

describe ApplicationController do
  let(:league) { FactoryGirl.build(:league, :id) }

  describe "#league_path" do
    it "returns correct path with hmac key" do
      subject.send(:league_path, league).should == "/leagues/#{league.to_param}?h=#{league.hmac}"
    end

    it "returns correct path with hmac key and optional parameters" do
      subject.send(:league_path, league, show_drafted: true).should == "/leagues/#{league.to_param}?h=#{league.hmac}&show_drafted=true"
    end

  end

  describe "#league_url" do
    it "returns correct path with hmac key" do
      subject.send(:league_url, league).should == "http://test.host/leagues/#{league.to_param}?h=#{league.hmac}"
    end

    context "for NBA league" do
      let(:league) { FactoryGirl.build(:nba_league, :id) }

      it "returns correct url with hmac key" do
        subject.send(:league_url, league).should == "http://nba.test.host/leagues/#{league.to_param}?h=#{league.hmac}"
      end
    end
  end
end
