require 'spec_helper'

describe Team do
  after :each do
    Team.instance_variable_set(:@all, nil)
  end

  describe '.filename' do
    it "is nfl_teams by default" do
      Team.filename.should == "nfl_teams"
    end

    it "is nba_teams if Sport is NBA" do
      Sport.key = :nba

      Team.filename.should == "nba_teams"
    end
  end

  describe '.all' do
    it "returns an array of 32 teams" do
      Team.all.to_set.size.should == 32
      Team.all.each { |t| t.should be_a Team }
    end

    it "sorts teams in descending order by expected wins" do
      Team.all.first.expected_wins.should == Team.all.map(&:expected_wins).max
      Team.all.last.expected_wins.should == Team.all.map(&:expected_wins).min
    end

    context "for NBA" do
      before(:each) { Sport.key = :nba }

      it "returns an array of 30 teams" do
        Team.all.to_set.size.should == 30
        Team.all.each { |t| t.should be_a Team }
      end
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
