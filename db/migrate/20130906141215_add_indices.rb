class AddIndices < ActiveRecord::Migration
  def change
    add_index :draft_picks, :league_id
    add_index :draft_picks, :member_id
    add_index :league_memberships, [:league_id, :member_id], unique: true
    add_index :leagues, :commissioner_id
    add_index :users, :email, unique: true
  end
end
