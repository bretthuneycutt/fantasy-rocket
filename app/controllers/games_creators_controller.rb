require 'games_creator'

class GamesCreatorsController < ApplicationController
  http_basic_authenticate_with name: "fantasyrocket", password: ENV['BASIC_AUTH_PW']  if ENV['BASIC_AUTH_PW']

  def create
    games_creator_class.new(params[:games_creator]).save!
    redirect_to regular_season_games_path, notice: "Thanks, we got it!"
  end

private

  def games_creator_params
    params[:nfl_games_creator] || params[:nba_games_creator]
  end

  def games_creator_class
    case current_sport
    when :nba
      NBAGamesCreator
    else
      NFLGamesCreator
    end
  end
end
