class SeasonMailerWorker
  include Sidekiq::Worker

  def perform(league_id)
    league = League.season('2013').find(league_id)

    SeasonMailer.new_season(league).deliver
  end
end
