class UsersController < ApplicationController
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

      redirect_to params[:redirect_to].presence || new_league_path, notice: "Thank you for signing up!"
    else
      render "new"
    end
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
