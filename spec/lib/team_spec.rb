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

  subject { Team.all.first }

  describe "#css_class" do
    it "returns the correct CSS class name" do
      subject.css_class.should == "atlanta-falcons"
    end
  end

  describe "#win_count" do
    context "if no wins recorded" do
      its(:win_count) { should == 0 }
    end

    context "if 1 win recorded" do
      before :each do
        FactoryGirl.create(:regular_season_game, winner_id: subject.id)
      end

      its(:win_count) { should == 1 }
    end
  end
end
