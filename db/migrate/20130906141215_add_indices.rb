class AddIndices < ActiveRecord::Migration
  def change
    add_index :draft_picks, :league_id
    add_index :draft_picks, :member_id
    add_index :league_memberships, :league_id
    add_index :league_memberships, :member_id
    add_index :leagues, :commissioner_id
    add_index :users, :email
  end
end
