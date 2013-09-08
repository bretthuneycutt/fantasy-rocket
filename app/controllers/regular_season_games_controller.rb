class RegularSeasonGamesController < ApplicationController
  http_basic_authenticate_with name: "fantasyrocket", password: ENV['BASIC_AUTH_PW']  if ENV['BASIC_AUTH_PW']

  def index
    @games = RegularSeasonGame.all
  end

  def new
    @regular_season_game = RegularSeasonGame.new
  end

  def create
    @regular_season_game = RegularSeasonGame.new(game_params)

    if @regular_season_game.save
      redirect_to regular_season_games_path
    else
      flash.now.alert = "Invalid"
      render :new
    end
  end

private

  def game_params
    params.require(:regular_season_game).permit(:winner_id, :week)
  end
end
