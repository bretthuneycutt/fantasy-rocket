class LeagueMembershipsController < ApplicationController
  before_filter :current_user!

  # TODO require hmac to join league
  def create
    @league = League.find(params[:league_id])
    @league.add_member(current_user)
    redirect_to league_path(@league, member: current_user.id)
  end
end
