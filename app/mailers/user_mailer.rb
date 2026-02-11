# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  def reset_password_email(user)
    @user = user
    @url  = edit_password_reset_url(@user.reset_password_token)

    mail(to: @user.email, subject: "【シャチククエスト】パスワード再設定のご案内")
  end
end
