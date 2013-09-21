require 'spec_helper'

describe Season do
  let(:league) { FactoryGirl.create(:league) }
  subject { Season.new(league) }

  context "when a win hasn't been registered" do
    it { should_not be_started }
  end

  context "when a win has been registered" do
    before(:each) { FactoryGirl.create(:regular_season_game) }

    it { should be_started }
  end
end
