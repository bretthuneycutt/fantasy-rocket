module ApplicationHelper

  # TODO test this method
  def link_to_join_league(league)
    options = {
      :class => "btn btn-main btn-xlg",
    }

    if current_user
      path = league_memberships_path(@league)
      options[:method] = "post"
    else
      path = new_user_path(redirect_to: league_path(league), league_id: league.id, h: league.hmac)
    end

    link_to "Join league", path, options
  end
end
