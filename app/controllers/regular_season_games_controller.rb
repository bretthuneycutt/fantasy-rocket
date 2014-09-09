require 'team'

class RegularSeasonGamesController < ApplicationController
  http_basic_authenticate_with name: "fantasyrocket", password: ENV['BASIC_AUTH_PW']  if ENV['BASIC_AUTH_PW']

  def index
    @games = game_class.all
  end

  def create
    @regular_season_game = game_class.new(game_params)

    if @regular_season_game.save
      redirect_to regular_season_games_url
    else
      flash.now.alert = "Invalid"
      render :new
    end
  end

private

  def game_params
    params.require(:regular_season_game).permit(:winner_id, :week)
  end

  def game_class
    case current_sport
    when :nba
      NBARegularSeasonGame
    else
      NFLRegularSeasonGame
    end
  end

  def team_class
    case current_sport
    when :nba
      NBATeam
    else
      NFLTeam
    end
  end
  helper_method :team_class
end
