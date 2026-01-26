class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :require_login
  before_action :check_today_status
  before_action :set_header_help_request

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
end
