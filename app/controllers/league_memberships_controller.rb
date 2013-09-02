class LeagueMembershipsController < ApplicationController

  def create
    @league = League.find(params[:league_id])

    unless current_user
      redirect_to new_user_path(redirect_to: league_path(@league)), notice: "Please sign up to join"
      return
    end

    unless @league.members.include? current_user
      @league.members << current_user
    end

    redirect_to league_path(@league)
  end
end
