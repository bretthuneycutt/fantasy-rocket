module ApplicationHelper

  # TODO test this method
  def link_to_join_league(league)
    text = "Join league"
    options = {
      :class => "btn btn-main btn-xlg",
    }

    if current_user
      path = league_memberships_url(@league)
      form_tag league_memberships_url(@league), :method => 'post', :class => 'join-league-form' do
        submit_tag "Join league", options
      end
    else
      path = new_users_url(redirect_to: league_url(league), league_id: league.id, h: league.hmac)
      options[:class] += " join-league-link"
      link_to text, path, options
    end
  end
end
