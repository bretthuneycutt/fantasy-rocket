class DraftPick < ActiveRecord::Base
  belongs_to :member, class_name: "User", inverse_of: :draft_picks
  belongs_to :league, inverse_of: :draft_picks

  # TODO rename to picked?
  def selected?
    !!team_id
  end

  def team
    @team ||= Team.find_by_id(team_id)  if team_id
  end

  delegate :draft, :to => :league

  def pick_team(team_id)
    team = Team.find_by_id(team_id)
    return  unless draft.available_teams.include? team
    update_attribute(:team_id, team_id)
  end
end
