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

    if @draft_pick.selected?
      # send relevant email
      mailer_worker_class = case @draft.status
      when :in_progress
        DraftPickMadeMailerWorker
      when :complete
        DraftCompleteMailerWorker
      end

      mailer_worker_class.perform_async(@league.id)

      # set draft to complete if appropriate
      @league.update_attributes!(draft_completed_at: Time.now)  if @draft.status == :complete
    end

    redirect_to league_path(@league, draft_pick: @draft_pick.id)
  end
end
