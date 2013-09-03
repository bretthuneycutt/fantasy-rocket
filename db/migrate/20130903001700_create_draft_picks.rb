class CreateDraftPicks < ActiveRecord::Migration
  def change
    create_table :draft_picks do |t|
      t.integer :league_id, :null => false
      t.integer :member_id, :null => false
      t.integer :order, :null => false
      t.integer :team_id
    end
    add_index :draft_picks, [:league_id, :team_id], :unique => true
  end
end
