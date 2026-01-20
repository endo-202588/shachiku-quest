class HelpersController < ApplicationController
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
