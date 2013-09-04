module ApplicationHelper

  # TODO test this method
  def link_to_join_league(league)
    text = "Join league"
    options = {
      :class => "btn btn-main btn-xlg",
    }

    if current_user
      path = league_memberships_path(@league)
      form_tag league_memberships_path(@league), :method => 'post', :class => 'join-league-form' do
        submit_tag "Join league", options
      end
    else
      path = new_user_path(redirect_to: league_path(league), league_id: league.id, h: league.hmac)
      options[:class] += " join-league-link"
      link_to text, path, options
    end
  end
end
