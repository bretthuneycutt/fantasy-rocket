require 'haml/template/plugin'

class DraftMailer < ActionMailer::Base
  default from: "FantasyRocket <hi@fantasyrocket.com>",
          content_type: "text/plain"

  def start_email(user, league)
    @user = user
    @league = league
    @draft = @league.draft

    mail({
      to: @user.email,
      subject: "The draft has started! #{@draft.current_picker.name} is up!",
    })
  end

  def pick_made_email(user, league)
    @user = user
    @league = league
    @draft = @league.draft

    mail({
      to: @user.email,
      subject: "#{@draft.last_pick.team.name} picked #{@draft.last_pick.as_ordinal}! #{@draft.current_picker.name} is up!",
    })
  end

  def draft_complete_email(user, league)
    @user = user
    @league = league
    @draft = @league.draft

    mail({
      to: @user.email,
      subject: "'#{@league.name}' draft is now complete!",
    })
  end
end
