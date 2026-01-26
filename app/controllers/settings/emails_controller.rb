class Settings::EmailsController < ApplicationController
  class Settings::EmailsController < ApplicationController
  before_action :require_login

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    # 1) 現在のパスワード確認
    unless correct_current_password?(@user, params[:current_password])
      @user.errors.add(:base, "現在のパスワードが正しくありません")
      return render :edit, status: :unprocessable_entity
    end

    # 2) 新しいメール（unconfirmed_email）を一時保存
    new_email = email_params[:email]

    if new_email.blank?
      @user.errors.add(:email, "新しいメールアドレスを入力してください")
      return render :edit, status: :unprocessable_entity
    end

    @user.unconfirmed_email = new_email

    # 3) 確認メール用トークンを生成
    @user.email_change_token = SecureRandom.hex(20)
    @user.email_change_token_expires_at = 30.minutes.from_now

    if @user.save
      # 4) メール送信（あとで作る）
      EmailChangeMailer.with(user: @user).confirmation.deliver_later

      redirect_to settings_profile_path,
        notice: "確認メールを送信しました。メール内のリンクをクリックして変更を完了してください。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def email_params
    params.require(:user).permit(:email)
  end

  # パスワード確認（Sorcery対応）
  def correct_current_password?(user, raw_password)
    return false if raw_password.blank?

    # Sorceryの標準 authenticate 方式
    if user.class.respond_to?(:authenticate)
      return user.class.authenticate(user.email, raw_password).present?
    end

    # その他プロジェクト依存方式
    if user.respond_to?(:valid_password?)
      return user.valid_password?(raw_password)
    end

    false
  end
end

end
