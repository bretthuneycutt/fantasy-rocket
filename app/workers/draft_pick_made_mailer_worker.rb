class DraftPickMadeMailerWorker
  include Sidekiq::Worker

  def perform(league_id)
    league = League.find(league_id)

    DraftMailer.pick_made_email(league).deliver
  end
end
