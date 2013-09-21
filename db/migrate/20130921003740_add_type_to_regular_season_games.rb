class AddTypeToRegularSeasonGames < ActiveRecord::Migration
  def self.up
    add_column :regular_season_games, :type, :string
    add_index :regular_season_games, :type
    RegularSeasonGame.find_each do |game|
      game.update_attribute(:type, "NFLRegularSeasonGame")
    end
  end

  def self.down
    remove_index :regular_season_games, :type
    remove_column :regular_season_games, :type
  end
end
