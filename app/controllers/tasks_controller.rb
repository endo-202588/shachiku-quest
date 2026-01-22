class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = current_user.tasks
                       .by_status(params[:status])
                       .order(created_at: :desc)
                       .decorate
  end

  def show
    @task = @task.decorate
    @help_request = @task.help_request&.decorate

    if @help_request.present? &&
      @task.user_id == current_user&.id &&
      @help_request.completed_notified_at.present? &&
      @help_request.completed_read_at.nil?

      @help_request.update_column(:completed_read_at, Time.current)
    end
  end

  def new
    @task = current_user.tasks.build(status: :in_progress)
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

  def help_requests
    @tasks = Task.help_request.includes(:user, :help_request).order(created_at: :desc).decorate
    @helpers = User.includes(:help_magic)
                  .joins(:help_magic)
                  .where('help_magics.available_date >= ?', Date.today)
                  .distinct
                  .order(:last_name, :first_name)
                  .decorate

    if current_user&.helper?
      @current_help_request =
        HelpRequest.find_by(helper_id: current_user.id, status: :matched)

      @helping_task = @current_help_request&.task&.decorate
    else
      @current_help_request = nil
      @helping_task = nil
    end
  end

  def edit
    # @task は before_action で設定済み
  end

  def update
    @task.assign_attributes(task_params)

    # ヘルプ要請で「選択してください」(空文字)が送信された場合のチェック
    if @task.help_request? && params[:help_request]&.[](:required_time).blank?
      @task.errors.add(:base, '必要な時間を選択してください')
      flash.now[:alert] = '必要な時間を選択してください'
      render :edit, status: :unprocessable_entity
      return
    end

    ActiveRecord::Base.transaction do
      # help_requestタイプの場合
      if @task.help_request?
        if @task.help_request.present?
          # 既存のhelp_requestを更新
          @task.help_request.assign_attributes(
            required_time: params[:help_request][:required_time],
            status: @task.help_request.status || :open
          )
        else
          # 新規作成
          @task.build_help_request(
            required_time: params[:help_request][:required_time],
            status: :open
          )
        end
      end

      if @task.save
        redirect_to tasks_path, notice: 'タスクを更新しました'
      else
        flash.now[:alert] = 'タスクの更新に失敗しました'
        render :edit, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:alert] = "更新に失敗しました: #{e.message}"
    render :edit, status: :unprocessable_entity
  end

  def add_helper
    @task = Task.find(params[:id])
    @helper = User.find(params[:helper_id]).decorate

    # ✅ ヘルパーが既に他のタスクをヘルプしていないかチェック
    unless helper_available?(@helper)
      redirect_to select_task_helper_path(@helper), alert: "#{@helper.full_name}さんは既に他のタスクをヘルプしています"
      return
    end

    # 時間がマッチするかチェック
    unless time_matchable?(@task, @helper)
      redirect_to select_task_user_path(@helper), alert: "#{@helper.full_name}さんの対応可能時間とタスクの必要時間が一致しません"
      return
    end

    # 既存のmatchableチェック
    unless @task.decorate.matchable?
      redirect_to select_task_user_path(@helper), alert: 'このタスクは既に仲間がいるか、ヘルプ要請されていません'
      return
    end

    # 仲間にする処理
    help_request = @task.help_request || @task.build_help_request

    help_request.assign_attributes(
      helper: @helper,
      status: :matched
    )

    if help_request.save
      redirect_to @task, notice: "#{@helper.decorate.full_name}さんが仲間になりました!"
    else
      redirect_to select_task_helper_path(@helper), alert: 'ヘルパーの追加に失敗しました'
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to help_requests_tasks_path, alert: 'ヘルパーまたはタスクが見つかりません'
  end

  def select_task
    @helper = User.includes(:help_magic).find(params[:id]).decorate
    @helper_available_time = @helper.help_magic&.available_time

    # 全てのヘルプ要請タスクを取得
    @matching_tasks = Task.help_request
                          .includes(:user, :help_request)
                          .order(created_at: :desc)
                          # decorateは削除 ✅
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
        valid_tasks << task_data
      else
        invalid_tasks << task_data
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

    if task.help_request?
      unless valid_required_time?(permitted_attr[:required_time])
        task.errors.add(:required_time, 'はヘルプ要請時に必須です。有効な時間を選択してください。')
        return { task: task, valid: false }
      end

      required_time_int = HelpRequest.required_times[permitted_attr[:required_time].to_s]

      task.build_help_request(
        required_time: required_time_int,
        status: :open
      )
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
      valid_tasks.each do |task_data|
        task_data[:task].save!
      end
    end

    redirect_to tasks_path, notice: "#{valid_tasks.size}件のタスクを登録しました"
  rescue ActiveRecord::RecordInvalid => e
    handle_save_error(e, valid_tasks.map { |td| td[:task] })
  rescue => e
    handle_unexpected_error(e, valid_tasks.map { |td| td[:task] })
  end


  def handle_validation_errors(valid_tasks, invalid_tasks)
    # valid_tasksからtaskオブジェクトを取り出す
    @tasks = valid_tasks.map { |td| td[:task] } + invalid_tasks.map { |td| td[:task] }
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
    # @task = current_user.tasks.find(params[:id])
    @task = Task.find(params[:id])
  end

  def helper_available?(helper)
    # helperが既にmatchedステータスのhelp_requestに紐づいていないかチェック
    !HelpRequest.exists?(helper: helper, status: :matched)
  end

  def time_matchable?(task, helper)
    helper_available_time = helper.help_magic&.available_time
    task_required_time = task.help_request&.required_time

    # どちらかがnilの場合はマッチしないと判定
    return false if helper_available_time.nil? || task_required_time.nil?

    # 時間が一致するかチェック
    helper_available_time == task_required_time
  end

  def task_params
    params.require(:task).permit(:title, :description, :status)
  end
end
