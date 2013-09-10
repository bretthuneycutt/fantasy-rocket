class WeeklyDigestMailerWorker
  include Sidekiq::Worker

  def perform(week, league_id)
    league = League.find(league_id)

    DigestMailer.weekly_summary(week, league).deliver
  end
end
