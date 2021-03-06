class DigestMailer < ActionMailer::Base
  add_template_helper(UrlHelper)
  default from: "FantasyRocket <hi@fantasyrocket.com>",
          content_type: "text/plain"

  def weekly_summary(week, league)
    @league = league
    @week = week

    mail({
      to: @league.members.map(&:email),
      subject: "Week #{week} standings - #{league.name}",
    })
  end
end
