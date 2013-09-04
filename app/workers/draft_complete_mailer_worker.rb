class DraftCompleteMailerWorker
  include Sidekiq::Worker

  def perform(user_id, league_id)
    user = User.find(user_id)
    league = League.find(league_id)

    DraftMailer.draft_complete_email(user, league).deliver
  end
end
