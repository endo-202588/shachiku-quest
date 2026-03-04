# app/controllers/oauth_controller.rb
class OauthController < ApplicationController
  skip_before_action :require_login
  skip_before_action :check_today_status
  skip_before_action :set_header_help_request
  skip_before_action :set_header_help_magic
  skip_before_action :daily_reset
  skip_before_action :set_unread_message_count

  # OmniAuth 2 は POST /auth/:provider を要求することが多い
  def passthru
    head :not_found
  end

  def callback
    auth = request.env["omniauth.auth"]
    email = auth.info.email&.downcase
    provider = auth.provider
    uid = auth.uid

    # 1) uid が既に別ユーザーに紐付いていたら拒否（安全対策）
    if (other = User.find_by(provider: provider, uid: uid)) && other.email.downcase != email
      return redirect_to login_path, danger: "別アカウントに紐付いたGoogleアカウントです"
    end

    # 2) まず email で既存ユーザーを探す（通常ログイン→Google連携のため）
    user = User.find_by("LOWER(email) = ?", email)

    if user
      user.update!(provider: provider, uid: uid)
    else
      # 3) 新規は必須項目が足りないので「仮登録」する
      password = SecureRandom.hex(16)

      # Googleの表示名（例: "Yuki Endo" / "遠藤 由紀"）
      full_name = auth.info.name.to_s.strip
      last_name, first_name = split_name_for_jp(full_name)

      user = User.create!(
        email: email,
        password: password,
        password_confirmation: password,
        provider: provider,
        uid: uid,

        # ここはあなたのUserバリデーションに合わせて「とりあえず通す値」
        last_name: last_name.presence || "未設定",
        first_name: first_name.presence || "未設定",
        last_name_kana: "みせってい",
        first_name_kana: "みせってい",
        department: "未設定"
      )
    end

    auto_login(user)

    # 4) プロフィール未入力なら編集へ誘導（Shachiku Quest向け）
    if profile_incomplete?(user)
      redirect_to edit_settings_profile_path, notice: "プロフィールを入力してください"
    else
      redirect_to dashboard_path, notice: "Googleでログインしました"
    end
  rescue ActiveRecord::RecordInvalid => e
    redirect_to login_path, danger: e.record.errors.full_messages.join(", ")
  end

  def failure
    redirect_to login_path, danger: "Googleログインに失敗しました"
  end

  private

  # 「未設定」が残ってる/空欄なら未完了扱い（好みに合わせて条件増やしてOK）
  def profile_incomplete?(user)
    user.department.blank? || user.department == "未設定" ||
      user.last_name.blank? || user.last_name == "未設定" ||
      user.first_name.blank? || user.first_name == "未設定" ||
      user.last_name_kana.blank? || user.last_name_kana == "みせってい" ||
      user.first_name_kana.blank? || user.first_name_kana == "みせってい"
  end

  # 日本語スペース/英語スペースどちらもそれっぽく分割
  def split_name_for_jp(full_name)
    return [ "", "" ] if full_name.blank?

    if full_name.include?("　") # 全角スペース
      full_name.split("　", 2)
    elsif full_name.include?(" ")
      full_name.split(" ", 2)
    else
      # 分割できない場合は姓に入れておく（あとでプロフィールで直す想定）
      [ full_name, "" ]
    end
  end
end
