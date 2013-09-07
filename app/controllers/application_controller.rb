class Unauthorized < StandardError
end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Unauthorized do
    render text: "Unauthorized (403)", status: 403
  end

  rescue_from ActiveRecord::RecordNotFound do
    render text: "Not found (404)", status: 404
  end

private

  def current_user
    @current_user ||= if cookies[:auth_token]
      User.find_by_auth_token!(cookies[:auth_token])
    elsif session[:user_id]
      # Legacy
      # Cookies implemented 9/6/2013
      # Can remove session a few weeks later

      User.find(session[:user_id])
    end
  end
  helper_method :current_user

  # TODO override these methods elsewhere so they work in mailer

  def league_url(league, params = {})
    root_url[0..-2] + league_path(league, params)
  end
  helper_method :league_url

  def league_path(league, params = {})
    params[:h] = league.hmac
    "/leagues/#{league.to_param}?#{params.to_param}"
  end
  helper_method :league_path
end
