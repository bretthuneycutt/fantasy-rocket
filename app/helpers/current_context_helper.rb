module CurrentContextHelper
  def current_user!
    @current_user ||= if cookies[:auth_token]
      User.find_by_auth_token!(cookies[:auth_token])
    elsif session[:user_id]
      # Legacy
      # Cookies implemented 9/6/2013
      # Can remove session a few weeks later

      User.find(session[:user_id])
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def current_user
    current_user!
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def current_sport
    @sport ||= case request.subdomain.split(".").first
    when 'nba'
      :nba
    else
      :nfl
    end
  end
end
