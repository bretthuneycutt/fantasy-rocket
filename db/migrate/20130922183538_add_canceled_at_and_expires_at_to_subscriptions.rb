class AddCanceledAtAndExpiresAtToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :canceled_at, :datetime
    add_column :subscriptions, :expires_at, :datetime, default: Time.at(0).to_datetime
    add_index :subscriptions, [:user_id, :canceled_at], unique: true
  end
end
