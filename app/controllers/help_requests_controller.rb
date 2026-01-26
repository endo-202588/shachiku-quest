class HelpRequestsController < ApplicationController
  before_action :require_login
  before_action :set_help_request, only: [:show, :update_status, :apply, :complete_form, :complete_notify]
  before_action :authorize_complete_notify!, only: [:complete_form, :complete_notify]

  def show
    unless @help_request.task.user_id == current_user&.id || @help_request.helper_id == current_user&.id
      redirect_to help_requests_tasks_path, alert: '権限がありません'
      return
    end

    task = @help_request.task
    @help_request_decorated = @help_request.decorate
    @task = task.decorate
  end

  def update_status
    new_status = params[:status].to_s

    unless @help_request.task.user_id == current_user&.id
      redirect_to task_path(@help_request.task), alert: '権限がありません'
      return
    end

    unless HelpRequest.statuses.key?(new_status)
      redirect_to task_path(@help_request.task), alert: '無効なステータスです'
      return
    end

    # ====== open に戻す：履歴退避＋リセット ======
    if new_status == "open"
      @help_request.assign_attributes(
        status: :open,
        last_helper_id: @help_request.helper_id, # ←退避（不要なら削除OK）
        helper_id: nil,
        completed_notified_at: nil
      )

      if @help_request.save
        redirect_to task_path(@help_request.task), notice: 'オープンに戻しました'
      else
        redirect_to task_path(@help_request.task), alert: @help_request.errors.full_messages.join(', ')
      end
      return
    end

    # ====== completed への遷移ガード（update前） ======
    if new_status == "completed"
      unless @help_request.matched?
        redirect_to task_path(@help_request.task), alert: '完了にできる状態ではありません'
        return
      end

      if @help_request.completed_notified_at.blank?
        redirect_to task_path(@help_request.task), alert: 'ヘルパーからの完了通知がまだです'
        return
      end

      if @help_request.helper_id.blank?
        redirect_to task_path(@help_request.task), alert: '担当ヘルパーが設定されていません'
        return
      end
    end

    if new_status == "cancelled"
      unless @help_request.open?
        redirect_to task_path(@help_request.task), alert: 'キャンセルできるのは募集中（open）のみです'
        return
      end
    end

    # ====== 更新 ======
    if @help_request.update(status: new_status)
      if new_status == "completed"
        helper = @help_request.helper
        hm = helper&.help_magic

        if hm.nil?
          Rails.logger.info "HelpMagic already nil: user_id=#{helper&.id}"
        end

        HelpRequestMailer.owner_thanks(@help_request.id).deliver_now

        if hm
          if hm.destroy
            Rails.logger.info "HelpMagic destroyed: id=#{hm.id} user_id=#{helper.id}"
          else
            Rails.logger.warn "HelpMagic destroy failed: #{hm.errors.full_messages}"
          end
        end
      end

      redirect_to task_path(@help_request.task), notice: 'ステータスを更新しました'
    else
      redirect_to task_path(@help_request.task),
                  alert: "ステータスの更新に失敗しました: #{@help_request.errors.full_messages.join(', ')}"
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
    if @help_request.matched? || @help_request.completed? || @help_request.cancelled?
      redirect_to help_requests_tasks_path, alert: 'この依頼はすでにマッチ済み、または終了しています'
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

  def complete_form
    # 表示だけ（@help_request は before_action でセット済み）
  end

  def complete_notify
    # 二重送信防止
    if @help_request.completed_notified_at.present?
      redirect_to help_request_path(@help_request), notice: 'すでに完了通知済みです'
      return
    end

    # ここで helper_message と notified_at を同時に保存
    if @help_request.update(complete_notify_params.merge(completed_notified_at: Time.current))
      HelpRequestMailer.completed_notify(@help_request.id).deliver_later
      redirect_to help_requests_tasks_path, notice: '完了を通知しました！'
    else
      flash.now[:alert] = @help_request.errors.full_messages.join(', ')
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
      redirect_to help_request_path(@help_request), alert: '完了通知できる状態ではありません'
      return
    end

    # 2) 担当ヘルパー本人だけが押せる
    unless @help_request.helper_id == current_user&.id
      redirect_to help_request_path(@help_request), alert: '権限がありません'
      return
    end

    # 3) すでに通知済みなら（フォームも開けない）
    if @help_request.completed_notified_at.present?
      redirect_to help_request_path(@help_request), notice: 'すでに完了通知済みです'
      return
    end
  end

  def set_help_request
    @help_request = HelpRequest.find(params[:id])
  end
end
