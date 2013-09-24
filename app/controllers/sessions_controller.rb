class SessionsController < ApplicationController
  force_ssl  unless Rails.env.development?

  def create
    email = params[:email].andand.downcase

    user = User.find_by_email(email)
    if user && user.authenticate(params[:password])
      login_user(user)
      redirect_to params[:redirect_to].presence || root_url
    else
      flash.now.alert = "Email or password is invalid"
      render "new"
    end
  end

  def destroy
    reset_session
    logout
    redirect_to root_url
  end
end
