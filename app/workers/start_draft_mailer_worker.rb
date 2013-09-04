class StartDraftMailerWorker
  include Sidekiq::Worker

  def perform(league_id)
    league = League.find(league_id)

    DraftMailer.start_email(league).deliver
  end
end
