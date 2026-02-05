class AdminUserChangeMailer < ApplicationMailer
  def password_changed
    @user = params[:user]
    @admin = params[:admin]
    mail(
      to: @user.email,
      subject: "【シャチーククエスト】管理者によってパスワードが変更されました"
    )
  end

  def email_changed
    @user = params[:user]
    @admin = params[:admin]
    @old_email = params[:old_email]
    @new_email = params[:new_email]

    mail(
      to: @new_email,
      subject: "【シャチーククエスト】管理者によってメールアドレスが変更されました"
    )
  end
end
