require 'draft_generator'

class DraftsController < ApplicationController
  def create
    @league = League.find(params[:league_id])

    raise Unauthorized  unless @league.commissioner == current_user

    DraftGenerator.new(@league).generate_picks!

    redirect_to league_url(@league)
  end
end
