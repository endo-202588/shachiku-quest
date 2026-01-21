class HelpRequestsController < ApplicationController
  before_action :set_help_request, only: [:show, :update_status, :apply, :complete_notify]

  def show
    unless @help_request.task.user_id == current_user&.id || @help_request.helper_id == current_user&.id
      redirect_to help_requests_tasks_path, alert: '権限がありません'
      return
    end

    task = @help_request.task
    @help_request = @help_request.decorate
    @task = task.decorate
  end

  def update_status
    new_status = params[:status]

    # タスクの所有者のみ変更可能
    unless @help_request.task.user_id == current_user&.id
      redirect_to task_path(@help_request.task), alert: '権限がありません'
      return
    end

    if HelpRequest.statuses.key?(new_status)
      if @help_request.update(status: new_status)
        redirect_to task_path(@help_request.task), notice: 'ステータスを更新しました'
      else
        # エラーメッセージを確認
        redirect_to task_path(@help_request.task), alert: "ステータスの更新に失敗しました: #{@help_request.errors.full_messages.join(', ')}"
      end
    else
      redirect_to task_path(@help_request.task), alert: '無効なステータスです'
    end
  end

  def apply
    # 1) ヘルパー登録していないなら不可
    unless current_user&.helper?
      redirect_to help_requests_tasks_path, alert: '先に魔法（対応可能時間）を登録してください'
      return
    end

    if @help_request.task.user_id == current_user.id
      redirect_to help_requests_tasks_path, alert: '自分のヘルプ要請には応募できません'
      return
    end

    # 2) すでに誰かがマッチしている/クローズなら不可（必要に応じて条件調整）
    if @help_request.matched? || @help_request.closed?
      redirect_to help_requests_tasks_path, alert: 'この依頼はすでにマッチ済み、またはクローズされています'
      return
    end

    # 3) すでに他タスクを手伝い中なら不可（あなたの既存ルール）
    if HelpRequest.exists?(helper_id: current_user.id, status: :matched)
      redirect_to help_requests_tasks_path, alert: 'すでに別の依頼をお手伝い中です'
      return
    end

    # 4) 時間マッチ判定（ここが肝）
    helper_time = current_user.help_magic&.available_time   # has_one想定
    task_time   = @help_request.required_time

    if helper_time.blank? || task_time.blank? || helper_time.to_s != task_time.to_s
      redirect_to help_requests_tasks_path, alert: '使える魔法が合いません（対応可能時間が一致しません）'
      return
    end

    # 5) マッチ成立：status=matched, helper_idセット
    if @help_request.update(status: :matched, helper_id: current_user.id)
      redirect_to help_requests_tasks_path, notice: '仲間に加わりました！'
    else
      redirect_to help_requests_tasks_path, alert: "応募に失敗しました: #{@help_request.errors.full_messages.join(', ')}"
    end
  end

  def complete_notify
    unless @help_request.task.user_id == current_user&.id || @help_request.helper_id == current_user&.id
      redirect_to help_requests_tasks_path, alert: '権限がありません'
      return
    end

    # 1) matched 以外では完了通知できない
    unless @help_request.matched?
      redirect_to help_request_path(@help_request.id), alert: '完了通知できる状態ではありません'
      return
    end

    # 2) 担当ヘルパー本人だけが押せる
    unless @help_request.helper_id == current_user&.id
      redirect_to help_request_path(@help_request.id), alert: '権限がありません'
      return
    end

    # 3) すでに通知済みなら二重送信防止
    if @help_request.completed_notified_at.present?
      redirect_to help_request_path(@help_request.id), notice: 'すでに完了通知済みです'
      return
    end

    # 4) 通知：DBに記録 + ステータスを closed に（あなたの仕様に合わせる）
    if @help_request.update(status: :closed, completed_notified_at: Time.current)
      redirect_to help_requests_tasks_path, notice: '完了を通知しました！'
    else
      redirect_to help_request_path(@help_request.id), alert: @help_request.errors.full_messages.join(', ')
    end
  end

  private

  def set_help_request
    @help_request = HelpRequest.find(params[:id])
  end
end
