require 'draft_generator'

class DraftsController < ApplicationController
  def create
    @league = League.find(params[:league_id])

    if @league.commissioner == current_user && @league.draft.status == :not_started
      DraftGenerator.new(@league).generate_picks!
    end

    redirect_to league_path(@league)
  end
end
