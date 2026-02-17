# frozen_string_literal: true

class Admin::BootstrapController < ApplicationController
  # アプリ側のログイン必須を一旦外す（tokenで守るため）
  # Sorceryなどで require_login が ApplicationController にある前提。
  skip_before_action :require_login, raise: false

  # 外部から叩くのでCSRFを無効化（tokenで認証する）
  protect_from_forgery with: :null_session

  def create
    # ★重要：adminが1人でも存在したら二度と使えない
    if User.where(role: "admin").exists?
      render json: { error: "bootstrap disabled" }, status: :forbidden
      return
    end

    token = params[:token].to_s
    unless secure_compare(token, ENV["ADMIN_BOOTSTRAP_TOKEN"].to_s)
      render json: { error: "invalid token" }, status: :unauthorized
      return
    end

    email = params[:email].to_s.strip.downcase
    user = User.find_by(email: email)

    unless user
      render json: { error: "user not found" }, status: :not_found
      return
    end

    user.update!(role: "admin")
    render json: { ok: true, email: user.email, role: user.role }, status: :ok
  end

  private

  def secure_compare(a, b)
    return false if a.blank? || b.blank?
    ActiveSupport::SecurityUtils.secure_compare(a, b)
  end
end
