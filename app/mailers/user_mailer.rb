class UserMailer < ActionMailer::Base
  default from: "FantasyRocket <hi@fantasyrocket.com>",
          content_type: "text/plain"

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password Reset"
  end
end
