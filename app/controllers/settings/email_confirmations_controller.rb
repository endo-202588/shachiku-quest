class Settings::EmailConfirmationsController < ApplicationController
  before_action :require_login

  def show
    token = params[:token].to_s
    if token.blank?
      return redirect_to settings_profile_path, alert: "トークンが見つかりません"
    end

    user = User.find_by(email_change_token: token)

    if user.nil?
      return redirect_to settings_profile_path, alert: "トークンが無効です"
    end

    if user.email_change_token_expires_at.blank? || user.email_change_token_expires_at < Time.current
      return redirect_to settings_profile_path, alert: "トークンの有効期限が切れています。もう一度メール変更をやり直してください"
    end

    if user.unconfirmed_email.blank?
      return redirect_to settings_profile_path, alert: "変更先メールが見つかりません。もう一度やり直してください"
    end

    # ここから確定処理
    user.email = user.unconfirmed_email
    user.unconfirmed_email = nil
    user.email_change_token = nil
    user.email_change_token_expires_at = nil

    user.save!
    redirect_to settings_profile_path, notice: "メールアドレスを更新しました"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to settings_profile_path, alert: "メールアドレスの更新に失敗しました: #{e.record.errors.full_messages.join(', ')}"
  end
end
