require 'spec_helper'

shared_examples "a team" do
  describe ".all" do
    it "returns only teams" do
      described_class.all.each { |t| t.should be_a Team }
    end

    it "sorts teams in descending order by expected wins" do
      described_class.all.first.expected_wins.should == described_class.all.map(&:expected_wins).max
      described_class.all.last.expected_wins.should == described_class.all.map(&:expected_wins).min
    end
  end

  context "if no wins recorded" do
    its(:win_count) { should == 0 }
  end

  context "if 1 win recorded" do
    before :each do
      sport = described_class.to_s.downcase[0..2]
      FactoryGirl.create("#{sport}_regular_season_game", winner_id: subject.id)
    end

    its(:win_count) { should == 1 }
  end
end

describe NBATeam do
  subject { NBATeam.all.first }
  it_behaves_like "a team"

  after(:each) { Team.instance_variable_set(:@all, nil) }

  describe ".filename" do
    it "is nfl_teams" do
      NBATeam.filename.should == "nba_teams"
    end
  end

  describe '.all' do
    it "returns an array of 30 teams" do
      NBATeam.all.to_set.size.should == 30
    end
  end

  its(:css_class) { should == "miami-heat" }
end

describe NFLTeam do
  subject { NFLTeam.all.first }
  it_behaves_like "a team"

  after(:each) { Team.instance_variable_set(:@all, nil) }

  describe ".filename" do
    it "is nfl_teams" do
      NFLTeam.filename.should == "nfl_teams"
    end
  end

  describe '.all' do
    it "returns an array of 32 teams" do
      NFLTeam.all.to_set.size.should == 32
    end
  end

  its(:css_class) { should == "atlanta-falcons" }
end
