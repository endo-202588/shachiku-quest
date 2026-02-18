class MessagesController < ApplicationController
  before_action :require_login

  def index
    @messages = current_user
      .received_help_request_messages
      .includes(:help_request, :sender)
      .order(created_at: :desc)
  end

  def show
    @message = current_user.received_help_request_messages.find(params[:id])
    @message.read!

    hr = @message.help_request
    me = current_user.id

    unless hr && (hr.task.user_id == me || hr.helper_id == me)
      redirect_to messages_path, danger: "このメッセージの詳細を表示する権限がありません"
      return
    end

    redirect_to help_request_path(hr)
  end
end
