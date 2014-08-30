class PasswordResetsController < ApplicationController
  def create
    if user = User.find_by_email(params[:email].andand.downcase)
      user.generate_token(:password_reset_token)
      user.password_reset_sent_at = Time.now
      user.save!

      PasswordResetMailerWorker.perform_async(user.id)
    end

    redirect_to root_url, notice: "Email sent with password reset instructions"
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_url, :alert => "Password reset has expired."
    elsif @user.update_attributes(user_params)
      redirect_to root_url, :notice => "Password has been reset!"
    else
      render :edit
    end
  end

private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
