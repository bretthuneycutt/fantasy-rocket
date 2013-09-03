class Team
  TOTAL_NUMBER = 32

  attr_reader :id, :name

  def self.all
    @all ||= YAML.load_file("./data/nfl_teams.yml").map do |attributes|
      Team.new(attributes)
    end
  end

  def initialize(attributes = {})
    @id = attributes['id']
    @name = attributes['name']
  end

  def self.find_by_id(team_id)
    team_id = team_id.to_i
    @teams_by_id ||= {}
    @teams_by_id[team_id] ||= all.detect {|t| t.id == team_id }
  end
end
