class NotificationsController < ApplicationController
  before_action :require_login

  def index
    @messages = current_user
      .received_notifications
      .includes(:help_request, :sender)
      .order(created_at: :desc)
  end

  def show
    @message = current_user.received_notifications.find(params[:id])
    @message.read!

    hr = @message.help_request
    me = current_user.id

    unless hr && (hr.task.user_id == me || hr.helper_id == me)
      redirect_to notifications_path, danger: "このメッセージの詳細を表示する権限がありません"
      return
    end
  end

  def create
    @help_request = HelpRequest.find(params[:help_request_id])

    me = current_user.id
    unless @help_request.task.user_id == me || @help_request.helper_id == me
      redirect_to help_request_path(@help_request), danger: "メッセージを送信する権限がありません"
      return
    end

    # sender は current_user、recipient はモデル側で解決する想定（なければ下で補足します）
    @message = @help_request.messages.create!(
      message_params.merge(sender: current_user)
    )

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to help_request_path(@help_request) }
    end
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
