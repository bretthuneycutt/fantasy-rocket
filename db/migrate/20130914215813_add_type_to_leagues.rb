class AddTypeToLeagues < ActiveRecord::Migration
  def self.up
    add_column :leagues, :type, :string, default: "NFLLeague"
  end

  def self.down
    remove_column :leagues, :type, :string
  end
end
