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
    @current_user ||= User.find(session[:user_id])  if session[:user_id]
  end
  helper_method :current_user

  def league_url(league)
    root_url + league_path(league)
  end

  def league_path(league)
    "/leagues/#{league.to_param}?h=#{league.hmac}"
  end
end
