class GenerateAuthTokensForUsers < ActiveRecord::Migration
  def self.up
    User.find_each do |u|
      u.generate_token(:auth_token)
      u.save!
    end
  end

  def self.down
  end
end
