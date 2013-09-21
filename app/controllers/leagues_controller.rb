class LeaguesController < ApplicationController
  # TODO - ensure user is logged in before_filter

  def new
    @league = League.new(sport: Sport.key)
  end

  def create
    @league = League.new(sport: Sport.key)
    @league.commissioner = current_user
    @league.attributes = league_params

    if @league.save
      redirect_to league_path(@league), notice: "Your league has been created!"
    else
      render "new"
    end
  end

  def show
    @league = League.find(params[:id])

    raise ActiveRecord::RecordNotFound  unless params[:h] == @league.hmac

    unless request.url == league_url(@league)
      redirect_to league_url(@league), status: 301
      return
    end

    @draft = @league.draft
    template = case @draft.status
    when :not_started
      'leagues/show/pre_draft'
    when :in_progress
      'drafts/show'
    when :complete
      'leagues/show/post_draft'
    end

    render template
  end

private

  def league_params
    params.require(:league).permit(:name)
  end
end
