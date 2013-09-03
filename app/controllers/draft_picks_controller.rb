# TODO simplify controller with service object

class DraftPicksController < ApplicationController
  def update
    @draft_pick = DraftPick.find(params[:id])

    raise Unauthorized  unless @draft_pick.member == current_user

    @draft_pick.pick_team(params[:team_id])

    # reload to ensure that draft status is up-to-date
    @draft_pick.reload
    @league = @draft_pick.league
    @draft = @league.draft

    # send relevant email
    if @draft_pick.selected?
      mailer_worker_class = case @draft.status
      when :in_progress
        DraftPickMadeMailerWorker
      when :complete
        DraftCompleteMailerWorker
      end

      @league.members.each do |m|
        mailer_worker_class.perform_async(m.id, @league.id)
      end
    end

    redirect_to league_path(@league)
  end
end
