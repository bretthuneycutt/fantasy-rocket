class AddDraftStatusColumnsToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :draft_started_at, :datetime
    add_column :leagues, :draft_completed_at, :datetime
  end
end
