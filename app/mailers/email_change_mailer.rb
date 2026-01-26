class EmailChangeMailer < ApplicationMailer
  def confirmation
    @user = params[:user]
    @url  = settings_email_confirm_url(token: @user.email_change_token)

    mail(to: @user.unconfirmed_email, subject: "【シャチーク】メールアドレス確認")
  end
end
