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
    @task = current_user.tasks.build(status: :todo)
  end

  def create
    tasks_attributes = params[:tasks] || []

    if tasks_attributes.empty?
      redirect_to new_task_path, alert: 'タスクが入力されていません'
      return
    end

    result = validate_and_prepare_tasks(tasks_attributes)

    if result[:invalid_tasks].empty?
      save_all_tasks(result[:valid_tasks])
    else
      handle_validation_errors(result[:valid_tasks], result[:invalid_tasks])
    end
  end

  def edit
    # @task は before_action で設定済み
  end

  def update
    # help_requestedに変更する場合
    if task_params[:status] == 'help_requested'
      ActiveRecord::Base.transaction do
        # help_requestがまだ存在しない場合は作成
        unless @task.help_request.present?
          @task.build_help_request(
            required_time: params[:required_time] || :half_hour,  # デフォルト値
            status: :open
          )
        end

        # タスクを更新
        if @task.update(task_params)
          redirect_to tasks_path, notice: 'タスクを更新し、ヘルプ要請を作成しました'
        else
          flash.now[:alert] = 'タスクの更新に失敗しました'
          render :edit, status: :unprocessable_entity
        end
      end
    else
      # 通常の更新
      if @task.update(task_params)
        redirect_to tasks_path, notice: 'タスクの更新に成功しました'
      else
        flash.now[:alert] = 'タスクの更新に失敗しました'
        render :edit, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    # エラーが発生した場合
    flash.now[:alert] = "更新に失敗しました: #{e.message}"
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @task.destroy!
    redirect_to tasks_path, notice: 'タスクを削除しました', status: :see_other
  end

  private

  def validate_and_prepare_tasks(tasks_attributes)
    valid_tasks = []
    invalid_tasks = []

    tasks_attributes.each do |task_attr|
      task_data = prepare_single_task(task_attr)
    
      if task_data[:valid]
        valid_tasks << task_data[:task]
      else
        invalid_tasks << task_data[:task]
      end
    end

    { valid_tasks: valid_tasks, invalid_tasks: invalid_tasks }
  end

  def prepare_single_task(task_attr)
    permitted_attr = task_attr.permit(:title, :status, :description, :required_time)

    task = current_user.tasks.build(
      title: permitted_attr[:title],
      status: permitted_attr[:status],
      description: permitted_attr[:description]
    )

    # enumの自動生成メソッドを使用
    if task.help_requested?
      unless valid_required_time?(permitted_attr[:required_time])
        task.errors.add(:required_time, 'はヘルプ要請時に必須です。有効な時間を選択してください。')
        return { task: task, valid: false }
      end

      # HelpRequestのenumを使用して整数値に変換
      required_time_value = HelpRequest.required_times[permitted_attr[:required_time].to_s]
      task.instance_variable_set(:@required_time, required_time_value)
    end

    { task: task, valid: task.valid? }
  end

  def valid_required_time?(required_time)
    return false if required_time.blank?

    # HelpRequestのenumで定義されている値かチェック
    HelpRequest.required_times.key?(required_time.to_s)
  end

  def save_all_tasks(valid_tasks)
    ActiveRecord::Base.transaction do
      valid_tasks.each do |task|
        task.save!
        create_help_request_if_needed(task)
      end
    end

    redirect_to users_path, notice: "#{valid_tasks.size}件のタスクを登録しました"
  rescue ActiveRecord::RecordInvalid => e
    handle_save_error(e, valid_tasks)
  rescue => e
    handle_unexpected_error(e, valid_tasks)
  end

  def create_help_request_if_needed(task)
    return unless task.help_requested?

    required_time = task.instance_variable_get(:@required_time)
    task.create_help_request!(
      required_time: required_time,
      status: :open
    )
  end

  def handle_validation_errors(valid_tasks, invalid_tasks)
    @tasks = valid_tasks + invalid_tasks
    flash.now[:alert] = 'タスクの登録に失敗しました。入力内容を確認してください。'
    render :new, status: :unprocessable_entity
  end

  def handle_save_error(error, tasks)
    flash.now[:alert] = "保存に失敗しました: #{error.message}"
    @tasks = tasks
    render :new, status: :unprocessable_entity
  end

  def handle_unexpected_error(error, tasks)
    flash.now[:alert] = "予期しないエラーが発生しました"
    Rails.logger.error(error)
    @tasks = tasks
    render :new, status: :unprocessable_entity
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status)
  end
end
