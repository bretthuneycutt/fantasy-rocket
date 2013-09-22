module CurrentContextHelper
  def current_user
    @current_user ||= if cookies[:auth_token]
      User.find_by_auth_token!(cookies[:auth_token])
    elsif session[:user_id]
      # Legacy
      # Cookies implemented 9/6/2013
      # Can remove session a few weeks later

      User.find(session[:user_id])
    end
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def current_user!
    redirect_to root_url, notice: "Must be logged in"  unless current_user
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
