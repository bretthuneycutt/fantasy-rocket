class ChangeRegularSeasonGameIndex < ActiveRecord::Migration
  def change
    remove_index :regular_season_games, [:winner_id, :week]
  end
end
