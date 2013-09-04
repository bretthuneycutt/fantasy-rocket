class DraftCompleteMailerWorker
  include Sidekiq::Worker

  def perform(league_id)
    league = League.find(league_id)

    DraftMailer.draft_complete_email(user, league).deliver
  end
end
