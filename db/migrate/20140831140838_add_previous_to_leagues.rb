class AddPreviousToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :previous_id, :integer
    add_index :leagues, :previous_id
  end
end
