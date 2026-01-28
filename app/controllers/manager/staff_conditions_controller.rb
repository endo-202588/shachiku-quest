class Manager::StaffConditionsController < ApplicationController
  before_action :require_manager!

  def index
    @departments = User.distinct.order(:department).pluck(:department).compact_blank
    @department  = params[:department].presence

    scope = User.order(:id)
           .includes(:statuses, :tasks) # 必要な関連だけ追加
           .page(params[:page]).per(12)

    scope = scope.where(department: @department) if @department.present? && @department != "all"

    @users = scope

    @decorated_users = UserDecorator.decorate_collection(@users)

    @data = @decorated_users.map do |user|
      {
        id: user.id,
        name: user.full_name,
        status_history: status_history_for(user),
        in_progress_tasks: in_progress_tasks_for(user),
        help_requests_30days: help_requests_30days_for(user) # 既に入れてるならそのまま
      }
    end
  end

  private

  def status_history_for(user)
    statuses = user.statuses
                  .where(status_date: 30.days.ago.to_date..Date.today)
                  .order(:status_date)

    statuses.map do |s|
      { date: s.status_date.to_s, value: s.status_type_before_type_cast }
    end
  end

  def in_progress_tasks_for(user)
    user.tasks.in_progress.count
  end

  def help_requests_30days_for(user)
    HelpRequest
      .joins(:task)
      .where(tasks: { user_id: user.id })
      .where(created_at: 30.days.ago.beginning_of_day..Time.current)
      .count
  end
end
