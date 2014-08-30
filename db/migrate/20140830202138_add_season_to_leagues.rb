class AddSeasonToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :season, :string
    add_index :leagues, :season
    League.find_each do |l|
      l.update_attributes!(season: '2013')
    end
  end
end
