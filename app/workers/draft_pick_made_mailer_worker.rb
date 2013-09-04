class DraftPickMadeMailerWorker
  include Sidekiq::Worker

  def perform(user_id, league_id)
    user = User.find(user_id)
    league = League.find(league_id)

    DraftMailer.pick_made_email(user, league).deliver
  end
end
