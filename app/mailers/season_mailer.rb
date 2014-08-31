class SeasonMailer < ActionMailer::Base
  add_template_helper(UrlHelper)
  default from: "FantasyRocket <hi@fantasyrocket.com>",
          content_type: "text/plain"

  def new_season(league)
    @league = league
    @new_league = league.next

    mail({
      to: @league.members.map(&:email),
      subject: "2014 season: #{@league.name}!",
    })
  end
end
