class HelpRequestsController < ApplicationController
  before_action :require_login
  before_action :set_help_request, only: [ :show, :update_status, :apply, :complete_form, :complete_notify ]
  before_action :authorize_complete_notify!, only: [ :complete_form, :complete_notify ]

  def index
    # 自分（発注者）のタスクに紐づく help_request
    base = HelpRequest.joins(:task).where(tasks: { user_id: current_user.id })

    # 完了通知が来ているもの（必要に応じて条件調整）
    @completed_requests = base
      .where.not(completed_notified_at: nil)
      .includes(:task, :helper)
      .order(completed_notified_at: :desc)

    # 未読だけ（バッジ用）
    @unread_completed_requests = @completed_requests.where(completed_read_at: nil)
  end

  def show
    task_owner = @help_request.task.user_id
    me = current_user&.id

    unless task_owner == me || @help_request.helper_id == me
      redirect_to help_requests_tasks_path, danger: "権限がありません"
      return
    end

    conversation = @help_request.conversation || @help_request.create_conversation!
    @chat_messages = conversation.messages.includes(:sender).order(:created_at)
    @chat_message  = conversation.messages.new

    if @help_request.completed_notified_at.present? && @help_request.completed_read_at.nil?
      @help_request.update_column(:completed_read_at, Time.current)
    end

    @help_request_decorated = @help_request.decorate
    @task = @help_request.task.decorate
  end

  def update_status
    new_status = params[:status].to_s

    # ====== 権限チェック ======
    unless @help_request.task.user_id == current_user&.id
      redirect_to task_path(@help_request.task), danger: "権限がありません"
      return
    end

    # ====== ステータス文字列の妥当性チェック ======
    unless HelpRequest.statuses.key?(new_status)
      redirect_to task_path(@help_request.task), danger: "無効なステータスです"
      return
    end

    # ====== open に戻す：履歴退避＋リセット ======
    if new_status == "open"
      begin
        @help_request.reset_to_open!
        redirect_to edit_task_path(@help_request.task), notice: "オープンに戻しました。付与ポイントを選び直してください"
      rescue ActiveRecord::RecordInvalid => e
        redirect_to task_path(@help_request.task), danger: e.record.errors.full_messages.join(", ")
      end
      return
    end

    # ====== completed への遷移ガード（update前） ======
    if new_status == "completed"
      unless @help_request.matched?
        redirect_to task_path(@help_request.task), danger: "完了にできる状態ではありません"
        return
      end

      if @help_request.completed_notified_at.blank?
        redirect_to task_path(@help_request.task), danger: "ヘルパーからの完了通知がまだです"
        return
      end

      if @help_request.helper_id.blank?
        redirect_to task_path(@help_request.task), danger: "担当ヘルパーが設定されていません"
        return
      end
    end

    # ====== cancelled への遷移ガード ======
    if new_status == "cancelled"
      unless @help_request.open?
        redirect_to task_path(@help_request.task), danger: "キャンセルできるのは募集中（open）のみです"
        return
      end
    end

    # ====== 更新本体 ======
    begin
      if new_status == "completed"
        # ✅ ここでモデルの共通処理を呼び出す
        @help_request.complete!(completed_by: current_user, send_thanks_notification: true)

        redirect_to task_path(@help_request.task), success: "ステータスを更新しました"
        return
      end

      # completed 以外（open / cancelled / matched など）の単純なステータス更新
      @help_request.update!(status: new_status)
      redirect_to task_path(@help_request.task), success: "ステータスを更新しました"

    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed => e
      msg =
        if e.respond_to?(:record) && e.record
          e.record.errors.full_messages.join(", ")
        else
          e.message
        end

      redirect_to task_path(@help_request.task),
                  danger: "ステータスの更新に失敗しました: #{msg}"
    end
  end

  def apply
    unless current_user&.helper?
      redirect_to help_requests_tasks_path, danger: "先に魔法（対応可能時間）を登録してください"
      return
    end

    if @help_request.task.user_id == current_user.id
      redirect_to help_requests_tasks_path, danger: "自分のヘルプ要請には応募できません"
      return
    end

    if @help_request.matched? || @help_request.completed? || @help_request.cancelled?
      redirect_to help_requests_tasks_path, danger: "この依頼はすでにマッチ済み、または終了しています"
      return
    end

    if HelpRequest.exists?(helper_id: current_user.id, status: :matched)
      redirect_to help_requests_tasks_path, danger: "すでに別の依頼をお手伝い中です"
      return
    end

    helper_time = current_user.help_magic&.available_time
    task_time   = @help_request.required_time

    if helper_time.blank? || task_time.blank? || helper_time.to_s != task_time.to_s
      redirect_to help_requests_tasks_path, danger: "使える魔法が合いません（対応可能時間が一致しません）"
      return
    end

    begin
      @help_request.with_lock do
        @help_request.reload

        if HelpRequest.exists?(helper_id: current_user.id, status: :matched)
          raise StandardError, "すでに別の依頼をお手伝い中です"
        end

        if @help_request.matched? || @help_request.completed? || @help_request.cancelled?
          raise StandardError, "この依頼はすでにマッチ済み、または終了しています"
        end

        @help_request.update!(
          status: :matched,
          helper_id: current_user.id,
          matched_on: Date.current
        )
      end

      redirect_to help_requests_tasks_path, success: "#{@help_request.helper.decorate.full_name}さんが仲間になりました！"

    rescue ActiveRecord::RecordInvalid => e
      redirect_to help_requests_tasks_path, danger: "応募に失敗しました: #{e.record.errors.full_messages.join(', ')}"
    rescue StandardError => e
      redirect_to help_requests_tasks_path, danger: e.message
    end
  end

  def complete_form
    # 表示だけ（@help_request は before_action でセット済み）
  end

  def complete_notify
    # 二重送信防止
    if @help_request.completed_notified_at.present?
      redirect_to help_request_path(@help_request), danger: "すでに完了通知済みです"
      return
    end

    # ここで helper_message と notified_at を同時に保存
    if @help_request.update(complete_notify_params.merge(completed_notified_at: Time.current))
      owner = @help_request.task.user

      Notification.create(
        help_request: @help_request,
        sender: current_user,          # ヘルパー（完了通知を押した人）
        recipient: owner,              # 依頼主
        message_type: :completed,
        body: (@help_request.helper_message.presence || "完了しました。ご確認ください。")
      )

      redirect_to help_requests_tasks_path, success: "完了を通知しました！"
    else
      flash.now[:danger] = @help_request.errors.full_messages.join(", ")
      render :complete_form, status: :unprocessable_entity
    end
  end

  private

  def complete_notify_params
    params.fetch(:help_request, {}).permit(:helper_message)
  end

  def authorize_complete_notify!
    # 1) matched 以外では完了通知できない
    unless @help_request.matched?
      redirect_to help_request_path(@help_request), danger: "完了通知できる状態ではありません"
      return
    end

    # 2) 担当ヘルパー本人だけが押せる
    unless @help_request.helper_id == current_user&.id
      redirect_to help_request_path(@help_request), danger: "権限がありません"
      return
    end

    # 3) すでに通知済みなら（フォームも開けない）
    if @help_request.completed_notified_at.present?
      redirect_to help_request_path(@help_request), danger: "すでに完了通知済みです"
      nil
    end
  end

  def set_help_request
    @help_request = HelpRequest.find(params[:id])
  end
end
