class Unauthorized < StandardError
end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include UrlHelper
  include I18nHelper
  include CurrentContextHelper

  rescue_from Unauthorized do
    render text: "Unauthorized (403)", status: 403
  end

  rescue_from ActiveRecord::RecordNotFound do
    render text: "Not found (404)", status: 404
  end

private

  def login_user(user)
    cookies[:auth_token] = {
      :value => user.auth_token,
      :domain => request.domain.prepend("."),
      :expires => 20.years.from_now.utc,
    }
  end

  def logout
    cookies.delete(:auth_token, domain: request.domain.prepend("."))
  end
end
