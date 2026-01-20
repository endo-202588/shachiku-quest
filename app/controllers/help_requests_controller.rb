class HelpRequestsController < ApplicationController
  before_action :set_help_request, only: [:update_status]

  def update_status
    new_status = params[:status]

    Rails.logger.debug "Received status: #{new_status.inspect}"
    Rails.logger.debug "All params: #{params.inspect}"

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

  private

  def set_help_request
    @help_request = HelpRequest.find(params[:id])
  end

  def set_task
    @task = Task.find(params[:task_id])
  end

  def help_request_params
    params.require(:help_request).permit(:status, :required_time)
  end
end
