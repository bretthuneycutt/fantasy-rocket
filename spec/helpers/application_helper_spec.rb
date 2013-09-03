require 'spec_helper'

describe ApplicationHelper do
  let(:league) { FactoryGirl.build(:league, :id) }

  describe "#league_path" do
    it "returns correct path with hmac key" do
      helper.league_path(league).should == "/leagues/#{league.to_param}?h=#{league.hmac}"
    end
  end

  describe "#league_url" do
    it "returns correct path with hmac key" do
      helper.league_url(league).should == "http://test.host/leagues/#{league.to_param}?h=#{league.hmac}"
    end
  end
end
