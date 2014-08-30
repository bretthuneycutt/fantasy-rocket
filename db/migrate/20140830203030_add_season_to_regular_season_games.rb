class AddSeasonToRegularSeasonGames < ActiveRecord::Migration
  def change
    add_column :regular_season_games, :season, :string, default: false
    add_index :regular_season_games, :season
    RegularSeasonGame.find_each do |g|
      g.update_attributes!(season: '2013')
    end
  end
end
