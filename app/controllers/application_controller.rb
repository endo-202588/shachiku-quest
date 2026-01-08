class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :require_login
  before_action :check_today_status
  add_flash_types :success, :danger

  private

  def not_authenticated
    redirect_to login_path, danger: 'ログインしてください'
  end

  def check_today_status
    return unless logged_in?
    return if controller_name == 'statuses'

    # 軽量なexists?を使ってチェック
    return if current_user.has_today_status?

    redirect_to new_status_path(date: Date.current), alert: "本日のステータスを登録してください"
  end
end
