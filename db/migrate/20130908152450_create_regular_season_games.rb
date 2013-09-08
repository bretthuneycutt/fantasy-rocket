class CreateRegularSeasonGames < ActiveRecord::Migration
  def change
    create_table :regular_season_games do |t|
      t.integer :winner_id
      t.integer :week

      t.timestamps

      t.index :winner_id
      t.index [:winner_id, :week], unique: true
    end
  end
end
