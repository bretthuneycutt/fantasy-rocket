class AddTimestampsToDraftPicks < ActiveRecord::Migration
  def change
    add_column :draft_picks, :created_at, :datetime
    add_column :draft_picks, :updated_at, :datetime
  end
end
