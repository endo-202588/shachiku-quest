class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :require_login
  before_action :check_today_status
  before_action :set_header_help_request
  before_action :set_header_help_magic
  before_action :daily_reset

  add_flash_types :success, :danger

  private

  def not_authenticated
    redirect_to login_path, danger: 'ログインしてください'
  end

  def check_today_status
    return unless logged_in?
    return if current_user.has_today_status?

    redirect_to new_status_path(date: Date.current), alert: "本日のステータスを登録してください"
  end

  def set_header_help_request
    return unless current_user&.helper?
    @header_help_request = HelpRequest.find_by(helper_id: current_user.id, status: :matched)
  end

  def set_header_help_magic
    return unless logged_in?
    @header_help_magic = current_user.help_magic&.decorate
  end

  def require_manager!
    unless current_user&.manager? || current_user&.admin?
      redirect_to root_path, alert: "権限がありません"
    end
  end

  def daily_reset
    return unless logged_in? # Sorcery 想定（違うならここだけ調整）
    ::DailyResetService.call
  end
end
