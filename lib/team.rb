class Team
  attr_reader :id, :name, :expected_wins

  def self.filename
    raise "Override in subclasses"
  end

  def self.win_counts
    raise "Override in subclasses"
  end

  def self.all
    @all ||= YAML.load_file("./data/#{filename}.yml").map do |attributes|
      new(attributes)
    end.sort_by(&:expected_wins).reverse
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
    self.class.win_counts[id] || 0
  end
end

class NBATeam < Team
  PHOENIX_SUNS = 27
  TOTAL_NUMBER = 30

  def self.filename
    "nba_teams"
  end

  def self.win_counts
    NBARegularSeasonGame.group(:winner_id).count
  end
end

class NFLTeam < Team
  ARIZONA_CARDINALS = 26
  DENVER_BRONCOS = 2
  TOTAL_NUMBER = 32

  def self.filename
    "nfl_teams"
  end

  def self.win_counts
    NFLRegularSeasonGame.group(:winner_id).count
  end
end
