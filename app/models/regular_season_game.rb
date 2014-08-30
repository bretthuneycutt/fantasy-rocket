require 'team'

class RegularSeasonGame < ActiveRecord::Base
  # TODO change week to date
  validates :week, presence: true, inclusion: { in: 1..17, message: "should span 1 to 17"}

  default_scope { where(season: ENV['CURRENT_SEASON']) }
  validates :season, presence: true
  before_validation :set_season

  def winner
    team_class.find_by_id(winner_id)
  end

  def team_class
    raise "Override in subclass"
  end

private

  def set_season
    self.season ||= ENV['CURRENT_SEASON']
  end
end
