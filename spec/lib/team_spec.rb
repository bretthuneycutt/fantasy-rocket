require 'spec_helper'

describe Team do
  describe '.all' do
    it "returns an array of 32 teams" do
      Team.all.to_set.size.should == 32
      Team.all.each { |t| t.should be_a Team }
    end

    it "sorts teams in descending order by expected wins" do
      Team.all.first.expected_wins.should == Team.all.map(&:expected_wins).max
      Team.all.last.expected_wins.should == Team.all.map(&:expected_wins).min
    end
  end

  describe "#css_class" do
    it "returns the correct CSS class name" do
      Team.all.first.css_class.should == "atlanta-falcons"
    end
  end
end
