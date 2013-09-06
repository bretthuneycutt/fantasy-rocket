class LeaguesController < ApplicationController
  # TODO - ensure user is logged in before_filter

  def new
    @league = League.new
  end

  def create
    @league = current_user.commissioned_leagues.new(league_params)

    if @league.save
      redirect_to league_path(@league), notice: "Your league has been created!"
    else
      render "new"
    end
  end

  def show
    @league = League.where(id: params[:id]).includes(:members, {draft_picks: :members}).first

    raise ActiveRecord::RecordNotFound  unless @league && params[:h] == @league.hmac

    @draft = @league.draft
    template = case @draft.status
    when :not_started, :complete
      'leagues/show'
    else
      'drafts/show'
    end

    render template
  end

private

  def league_params
    params.require(:league).permit(:name)
  end
end
