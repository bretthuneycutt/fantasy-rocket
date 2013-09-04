class SessionsController < ApplicationController
  def create
    email = params[:email].andand.downcase

    user = User.find_by_email(email)
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to params[:redirect_to].presence || root_url
    else
      flash.now.alert = "Email or password is invalid"
      render "new"
    end
  end

  def destroy
    reset_session
    redirect_to root_url
  end
end
