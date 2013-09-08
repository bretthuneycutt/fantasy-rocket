class Team
  ARIZONA_CARDINALS = 26
  DENVER_BRONCOS = 2
  TOTAL_NUMBER = 32

  attr_reader :id, :name, :expected_wins

  def self.all
    @all ||= YAML.load_file("./data/nfl_teams.yml").map do |attributes|
      Team.new(attributes)
    end.sort_by(&:expected_wins).reverse
  end

  def self.win_counts
    # TODO memoize
    RegularSeasonGame.group(:winner_id).count
  end

  def initialize(attributes = {})
    @id = attributes['id']
    @name = attributes['name']
    @expected_wins = attributes['ew']
  end

  def self.find_by_id(team_id)
    team_id = team_id.to_i
    @teams_by_id ||= {}
    @teams_by_id[team_id] ||= all.detect {|t| t.id == team_id }
  end

  def css_class
    name.downcase.gsub(/[\s\.]+/, "-")
  end

  def win_count
    Team.win_counts[id] || 0
  end
end
