class UsersController < ApplicationController
  before_filter :current_user!, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login_user(@user)

      # join user to a league if specificed
      if params[:league_id].presence
        league = League.find(params[:league_id])
        league.add_member(@user)  if league.hmac == params[:h]
      end

      redirect_to params[:redirect_to].presence || new_league_url, notice: "Thank you for signing up!"
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if current_user.update_attributes(user_params)
      redirect_to root_url, notice: "Thanks! We got your changes."
    else
      flash.now.alert = "That didn't work."
      render "edit"
    end
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
