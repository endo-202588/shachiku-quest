class Admin::TasksController < Admin::BaseController
  before_action :set_task, only: %i[edit update destroy]

  def index
    @tasks = Task.includes(:user).order(updated_at: :desc)
  end

  def edit
  end

  def update
    tp = task_params.to_h
    hrp = tp.delete("help_request_attributes") || {}

    service = Tasks::UpdateService.new(
      task: @task,
      task_params: tp,
      help_request_params: hrp
    )

    service.call!

    redirect_to(params[:return_to].presence || admin_tasks_path, success: "タスクを更新しました")

  rescue Tasks::UpdateService::ValidationError => e
    flash.now[:danger] = "タスクの更新に失敗しました: #{e.task.errors.full_messages.join(', ')}"
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @task.destroy!
    redirect_to admin_tasks_path, success: "削除しました"
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(
      :title, :description, :status,
      help_request_attributes: [:id, :required_time, :request_message, :virtue_points]
    )
  end
end
