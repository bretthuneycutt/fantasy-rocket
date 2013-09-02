class League < ActiveRecord::Base
  validates :name, presence: true
  validates :commissioner_id, presence: true

  belongs_to :commissioner, class_name: "User", inverse_of: :leagues
end
