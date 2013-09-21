class AddTypeToLeagues < ActiveRecord::Migration
  def self.up
    add_column :leagues, :sport, :string, default: "nfl"
  end

  def self.down
    remove_column :leagues, :sport, :string
  end
end
