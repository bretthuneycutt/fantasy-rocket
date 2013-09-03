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

  def pick_made_email(user_id, league_id)
    @user = User.find(user_id)
    @league = League.find(league_id)
    @draft = @league.draft

    mail({
      to: @user.email,
      subject: "#{@draft.last_pick.team.name} has been selected! #{@draft.current_picker.name} is up!",
    })
  end

  def draft_complete_email(user_id, league_id)
    @user = User.find(user_id)
    @league = League.find(league_id)
    @draft = @league.draft

    mail({
      to: @user.email,
      subject: "Draft for #{@league.name} is now complete!",
    })
  end
end
