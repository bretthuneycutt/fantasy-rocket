class GamesCreator
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :week, *(1..32).map { |t| "team_#{t}" }
  attr_reader :winning_team_ids

  def initialize(attributes = {})
    @week = attributes['week']
    @winning_team_ids = []

    (1..32).each do |t|
      @winning_team_ids << t  if attributes["team_#{t}"] == "1"
    end
  end

  def save!
    winning_team_ids.each do |t_id|
      game_class.create!(week: week, winner_id: t_id)
    end
  end

  def persisted?
    false
  end
end

class NFLGamesCreator < GamesCreator
  def game_class
    NFLRegularSeasonGame
  end
end

class NBAGamesCreator < GamesCreator
  def game_class
    NBARegularSeasonGame
  end
end
