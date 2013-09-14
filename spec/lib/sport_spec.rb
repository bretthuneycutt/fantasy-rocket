require 'spec_helper'

describe Sport do
  describe ".key" do
    it "is NFL by default" do
      Sport.key.should == :nfl
    end

    it "is NBA if set as such" do
      Sport.key = 'nba'

      Sport.key.should == :nba
    end
  end
end
