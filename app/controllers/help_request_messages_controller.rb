class HelpRequestMessagesController < ApplicationController
  before_action :require_login

  before_action :set_help_request, only: [:create]
  before_action :authorize_conversation_member!, only: [:create]

  def index
    @messages = current_user
      .received_help_request_messages
      .includes(help_request: :task, sender: {})
      .order(created_at: :desc)
  end

  def show
    @message = current_user
      .received_help_request_messages
      .includes(help_request: :task, sender: {})
      .find(params[:id])

    @message.read!
  end

  def create
    conversation = @help_request.conversation || @help_request.create_conversation!

    @message = conversation.messages.new(message_params)
    @message.sender = current_user
    @message.message_type = :user

    if @message.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to help_request_path(@help_request), success: "送信しました" }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:danger] = @message.errors.full_messages.join(", ")
          render turbo_stream: turbo_stream.replace(
            "chat_form",
            partial: "messages/form",
            locals: { help_request: @help_request, message: @message }
          )
        end
        format.html { redirect_to help_request_path(@help_request), danger: @message.errors.full_messages.join(", ") }
      end
    end
  end

  private

  def set_help_request
    @help_request = HelpRequest.find(params[:help_request_id])
  end

  def authorize_conversation_member!
    owner_id = @help_request.task.user_id
    helper_id = @help_request.helper_id
    me = current_user.id

    allowed = (me == owner_id) || (helper_id.present? && me == helper_id)
    return if allowed

    redirect_to help_requests_tasks_path, danger: "権限がありません" and return
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
