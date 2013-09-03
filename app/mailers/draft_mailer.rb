require 'haml/template/plugin'

class DraftMailer < ActionMailer::Base
  default from: "hi@fantasyrocket.com",
          content_type: "text/plain"

  def start_email(user_id, league_id)
    @user = User.find(user_id)
    @league = League.find(league_id)
    @draft = @league.draft

    mail({
      to: "#{@user.name} <@user.email>",
      subject: DraftEmailSubject.new(@draft, @user).to_s,
    })
  end
end
