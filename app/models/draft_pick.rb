class DraftPick < ActiveRecord::Base
  belongs_to :member, class_name: "User", inverse_of: :draft_picks
  belongs_to :league, inverse_of: :draft_picks

  scope :picked, -> { where('team_id IS NOT NULL') }

  delegate :team_class, to: :league

  # TODO rename to picked?
  def selected?
    !!team_id
  end

  def team
    @team ||= team_class.find_by_id(team_id)  if team_id
  end

  delegate :draft, :to => :league

  def pick_team(team_id)
    team = team_class.find_by_id(team_id)
    return  unless draft.available_teams.include? team
    update_attribute(:team_id, team_id)
  end

  def as_ordinal
    (order + 1).ordinalize
  end

  def default_tweet
    return  unless team

    "I picked the #{team.name} #{as_ordinal}"
  end
end
