class HelpersController < ApplicationController
  def helping
    return redirect_to help_requests_tasks_path, alert: 'ヘルパーではありません' unless current_user&.helper?

    @help_request =
      HelpRequest.includes(task: :user).find_by(helper_id: current_user.id, status: :matched)

    return redirect_to help_requests_tasks_path, alert: '現在ヘルプ中のタスクはありません' unless @help_request

    @help_request_decorated = @help_request.decorate
    @task = @help_request.task.decorate

    render 'help_requests/show'
  end

  def select_task
    @helper = User.includes(:help_magic).find(params[:id]).decorate
    @helper_available_time = @helper.help_magic&.available_time

    # 時間がマッチするヘルプ要請タスクのみを取得
    @matching_tasks = Task.help_request
                          .includes(:user, :help_request)
                          .order(created_at: :desc)
                          .decorate
  end
end
