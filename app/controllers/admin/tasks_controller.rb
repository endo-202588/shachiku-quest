class Admin::TasksController < Admin::BaseController
  def index
    @tasks = Task.includes(:user).order(updated_at: :desc)
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      redirect_to admin_tasks_path, notice: "更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy!
    redirect_to admin_tasks_path, notice: "削除しました"
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :status)
  end
end
