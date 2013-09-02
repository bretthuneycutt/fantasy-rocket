class LeaguesController < ApplicationController
  # TODO - ensure user is logged in before_filter

  def new
    @league = League.new
  end

  def create
    @league = current_user.commissioned_leagues.new(league_params)
    if @league.save
      # TODO - where should this redirect to?
      redirect_to "/", notice: "Your league has been created!"
    else
      render "new"
    end
  end

private

  def league_params
    params.require(:league).permit(:name)
  end
end
