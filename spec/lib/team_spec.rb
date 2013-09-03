require 'spec_helper'

describe Team do
  describe '.all' do
    it "returns an array of 32 teams" do
      Team.all.size.should == 32
      yaml = YAML.load_file("./data/nfl_teams.yml")
      Team.all.each_with_index do |team, i|
        team.should be_a Team
        team.name.should == yaml[i]['name']
        team.id.should == yaml[i]['id']
      end
    end
  end
end
