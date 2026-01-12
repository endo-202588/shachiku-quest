class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = current_user.tasks
                       .by_status(params[:status])
                       .order(created_at: :desc)
                       .decorate
  end

  def show
  end

  def new
    @task = current_user.tasks.build(status: :todo, required_time: :half_hour)
  end

  def create
    tasks_attributes = params[:tasks] || []

    # 空の配列チェック
    if tasks_attributes.empty?
      redirect_to new_task_path, alert: 'タスクが入力されていません'
      return
    end

    # 各タスクのバリデーションチェック
    valid_tasks = []
    invalid_tasks = []

    tasks_attributes.each do |task_attr|
      task = current_user.tasks.build(task_attr.permit(:title, :status, :required_time, :description))
      if task.valid?
        valid_tasks << task
      else
        invalid_tasks << task
      end
    end

    # すべてのタスクが有効な場合のみ保存
    if invalid_tasks.empty?
      # バリデーションエラーがない場合
      begin
        ActiveRecord::Base.transaction do
          valid_tasks.each(&:save!)
        end
        redirect_to users_path, notice: "#{valid_tasks.size}件のタスクを登録しました"
      rescue ActiveRecord::RecordInvalid => e
        # 予期しないバリデーションエラー
        flash.now[:alert] = "保存に失敗しました: #{e.message}"
        @tasks = valid_tasks + invalid_tasks
        render :new, status: :unprocessable_entity
      rescue => e
        # その他のエラー
        flash.now[:alert] = "予期しないエラーが発生しました"
        Rails.logger.error(e)
        @tasks = valid_tasks + invalid_tasks
        render :new, status: :unprocessable_entity
      end
    else
      # エラーがある場合は最初のエラーを表示
      @tasks = valid_tasks + invalid_tasks
      flash.now[:alert] = 'タスクの登録に失敗しました。入力内容を確認してください。'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @task は before_action で設定済み
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: 'タスクの更新に成功しました'
    else
      flash.now[:alert] = 'タスクの更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy!
    redirect_to tasks_path, notice: 'タスクを削除しました', status: :see_other
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :required_time)
  end
end
