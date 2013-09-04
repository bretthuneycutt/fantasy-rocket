class LeagueMembershipsController < ApplicationController

  def create
    @league = League.find(params[:league_id])
    raise Unauthorized  unless current_user
    @league.add_member(current_user)
    redirect_to league_path(@league)
  end
end
