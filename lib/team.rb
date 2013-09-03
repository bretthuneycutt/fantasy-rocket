class Team
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

  def self.size
    @size ||= all.size
  end

  def self.find_by_id(team_id)
    @teams_by_id ||= {}
    @teams_by_id[team_id] ||= all.detect {|t| t.id == team_id }
  end
end
