class Unauthorized < StandardError
end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_sport

  include UrlHelper

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
  rescue ActiveRecord::RecordNotFound
    reset_session
    cookies.delete(:auth_token)
    nil
  end
  helper_method :current_user

  def set_sport
    sport = case request.subdomain
    when 'nba'
      :nba
    else
      :nfl
    end

    Sport.key = sport
  end
end
