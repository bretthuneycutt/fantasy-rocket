require 'haml/template/plugin'

class DraftMailer < ActionMailer::Base
  default from: "hi@fantasyrocket.com",
          content_type: "text/plain"

  def start_email(user_id, league_id)
    @user = User.find(user_id)
    @league = League.find(league_id)
    @draft = @league.draft

    mail({
      to: @user.email,
      subject: "Your NFL Wins Pool draft has started! #{@draft.current_picker.name} is up!",
    })
  end
end
