class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :require_login
  before_action :refresh_daily_state
  before_action :check_today_status
  before_action :set_header_help_request

  add_flash_types :success, :danger

  private

  def not_authenticated
    redirect_to login_path, danger: 'ログインしてください'
  end

  def refresh_daily_state
    return unless logged_in?

    current_user.invalidate_help_magic_if_expired!
    reset_yesterday_matched_help_requests!
  end

  def reset_yesterday_matched_help_requests!
    beginning_of_today = Time.zone.now.beginning_of_day

    HelpRequest.joins(:task)
               .where(tasks: { user_id: current_user.id })
               .where(status: :matched)
               .where("help_requests.updated_at < ?", beginning_of_today)
               .find_each do |hr|
                 hr.update!(status: :open)  # ← last_helper_id 退避 & helper_id=nil が走る
               end
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
