module TasksHelper
  def status_options_for_select
    Task.statuses.keys.map { |key| [I18n.t("activerecord.enums.task.status.#{key}"), key] }
  end

  # def required_time_options_for_select
  #   Task.required_times.keys.map { |key| [I18n.t("activerecord.enums.task.required_time.#{key}"), key] }
  # end

  def tab_link_class(status)
    base_class = "px-4 py-2 transition-colors duration-200"

    if active_tab?(status)
      "#{base_class} border-b-2 border-indigo-500 font-bold text-indigo-600"
    else
      "#{base_class} text-gray-500 hover:text-gray-700"
    end
  end

  def task_count_by_status(status)
    if status.nil?
      current_user.tasks.count
    else
      current_user.tasks.where(status: status).count
    end
  end

  private

  def active_tab?(status)
    (status.nil? && params[:status].blank?) || params[:status] == status
  end
end
