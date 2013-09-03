class DraftPick < ActiveRecord::Base
  belongs_to :member, class_name: "User", inverse_of: :draft_picks
  belongs_to :league, inverse_of: :draft_picks

  def selected?
    !!team_id
  end

  def team
    @team ||= Team.find_by_id(team_id)  if team_id
  end
end
