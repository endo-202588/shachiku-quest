class DashboardController < ApplicationController
  before_action :require_login

  def show
    @today_status = current_user.statuses.find_by(status_date: Date.current)&.decorate
    @today_tasks  = current_user.tasks.order(updated_at: :desc).limit(5).decorate

    help_requests = current_user.help_requests.includes(:task)

    @hr_open = help_requests.open
    @hr_matched = help_requests.matched
    @hr_completed_unread = help_requests
      .where.not(completed_notified_at: nil)
      .where(completed_read_at: nil)
    @hr_cancelled = help_requests.cancelled

    @helping_request =
    HelpRequest.includes(task: :user)
               .find_by(helper_id: current_user.id, status: :matched)

    @help_magic = current_user.help_magic
  end
end
