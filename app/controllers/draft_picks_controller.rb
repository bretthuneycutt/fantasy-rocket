class DraftPicksController < ApplicationController
  def update
    @draft_pick = DraftPick.find(params[:id])

    raise Unauthorized  unless @draft_pick.member == current_user

    @draft_pick.pick_team(params[:team_id])
    redirect_to league_path(@draft_pick.league)
  end
end
