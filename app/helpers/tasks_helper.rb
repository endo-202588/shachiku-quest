module TasksHelper
  def status_options_for_select
    Task.statuses.keys.map { |key| [I18n.t("activerecord.enums.task.status.#{key}"), key] }
  end

  def required_time_options_for_select
    Task.required_times.keys.map { |key| [I18n.t("activerecord.enums.task.required_time.#{key}"), key] }
  end
end
