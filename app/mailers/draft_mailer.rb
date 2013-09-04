require 'haml/template/plugin'

class DraftMailer < ActionMailer::Base
  default from: "FantasyRocket <hi@fantasyrocket.com>",
          content_type: "text/plain"

  def start_email(league)
    @league = league
    @draft = @league.draft

    mail({
      to: @league.members.map(&:email),
      subject: "The draft has started! #{@draft.current_picker.name} is up!",
    })
  end

  def pick_made_email(league)
    @league = league
    @draft = @league.draft

    mail({
      to: @league.members.map(&:email),
      subject: "#{@draft.last_pick.team.name} picked #{@draft.last_pick.as_ordinal}! #{@draft.current_picker.name} is up!",
    })
  end

  def draft_complete_email(league)
    @league = league
    @draft = @league.draft

    mail({
      to: @league.members.map(&:email),
      subject: "'#{@league.name}' draft is now complete!",
    })
  end
end
