class DraftPick < ActiveRecord::Base
  belongs_to :member, class_name: "User", inverse_of: :draft_picks
  belongs_to :league, inverse_of: :draft_picks
end
