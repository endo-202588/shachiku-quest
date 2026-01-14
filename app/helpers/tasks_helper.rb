module TasksHelper
  def status_options_for_select
    Task.task_types.keys.map { |key| [I18n.t("activerecord.enums.task.task_type.#{key}"), key] }
  end

  # def required_time_options_for_select
  #   Task.required_times.keys.map { |key| [I18n.t("activerecord.enums.task.required_time.#{key}"), key] }
  # end

  def tab_link_class(task_type)
    base_class = "px-4 py-2 transition-colors duration-200"

    if active_tab?(task_type)
      "#{base_class} border-b-2 border-indigo-500 font-bold text-indigo-600"
    else
      "#{base_class} text-gray-500 hover:text-gray-700"
    end
  end

  def task_count_by_task_type(task_type)
    if task_type.nil?
      current_user.tasks.count
    else
      current_user.tasks.where(task_type: task_type).count
    end
  end

  private

  def active_tab?(task_type)
    (task_type.nil? && params[:task_type].blank?) || params[:task_type] == task_type
  end
end
