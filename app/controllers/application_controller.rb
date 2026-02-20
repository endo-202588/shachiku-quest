class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :require_login
  before_action :check_today_status
  before_action :set_header_help_request
  before_action :set_header_help_magic
  before_action :daily_reset
  before_action :set_unread_message_count

  add_flash_types :success, :danger

  helper_method :safe_return_path

  private

  def not_authenticated
    redirect_to login_path, danger: "ログインしてください"
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
      redirect_to root_path, danger: "権限がありません"
    end
  end

  def set_unread_message_count
    return unless current_user
    @unread_message_count = current_user.received_notifications.unread.count
  end

  def daily_reset
    return unless logged_in? # Sorcery 想定（違うならここだけ調整）
    ::DailyResetService.call
  end

  def safe_return_path(fallback)
    raw = params[:return_to].to_s

    # 値が空ならフォールバック
    return fallback if raw.blank?

    # 先頭が "/" でない（相対パスじゃない）なら却下
    return fallback unless raw.start_with?("/")

    # "//evil.com" みたいな形式は却下
    return fallback if raw.start_with?("//")

    # "javascript:..." などのスキームっぽいものも念のため弾く
    return fallback if raw.strip =~ /\Ajavascript:/i

    # 上記を全部クリアしたものだけ、そのままパスとして使う
    raw
  end
end
