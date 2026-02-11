class PasswordResetsController < ApplicationController
  skip_before_action :require_login, raise: false

  def new
  end

  def create
    @user = User.find_by(email: params[:email].to_s.strip.downcase)

    @user&.deliver_reset_password_instructions!

    redirect_to login_path, success: "パスワード再設定の案内をメールで送信しました（該当するアカウントがある場合）。"
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)

    unless @user
      redirect_to new_password_resets_path, danger: "リンクが無効、または期限切れです。"
    end
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)

    unless @user
      redirect_to new_password_resets_path, danger: "リンクが無効、または期限切れです。"
      return
    end

    password = params[:password].to_s
    password_confirmation = params[:password_confirmation].to_s

    if password.blank?
      flash.now[:danger] = "パスワードを入力してください"
      render :edit, status: :unprocessable_entity
      return
    end

    if password != password_confirmation
      flash.now[:danger] = "パスワード確認が一致しません"
      render :edit, status: :unprocessable_entity
      return
    end

    @user.password = password
    @user.password_confirmation = password_confirmation

    if @user.save
      @user.clear_reset_password_token_change
      redirect_to login_path, success: "パスワードを更新しました。ログインしてください。"
    else
      flash.now[:danger] = "更新に失敗しました: #{@user.errors.full_messages.join(', ')}"
      render :edit, status: :unprocessable_entity
    end
  end
end
