class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @task = current_user.tasks.build(status: :todo, required_time: :half_hour)
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to users_path, notice: 'タスクの新規登録に成功しました'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: 'タスクの更新に成功しました'
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'タスクの削除に成功しました'
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :required_time)
  end
end
