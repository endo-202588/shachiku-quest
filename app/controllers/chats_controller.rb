class ChatsController < ApplicationController
  before_action :require_login
  before_action :set_help_request
  before_action :authorize_conversation_member!

  def show
    conversation = @help_request.conversation || @help_request.create_conversation!
    @messages = conversation.messages.includes(:sender).order(:created_at)
    @message  = conversation.messages.new
  end

  def create
    return head :forbidden unless @help_request.matched?
    
    conversation = @help_request.conversation || @help_request.create_conversation!

    @message = conversation.messages.new(message_params)
    @message.sender = current_user
    @message.message_type = :user

    if @message.save
      @new_message = conversation.messages.new

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to help_request_chat_path(@help_request), success: "送信しました" }
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
        format.html { redirect_to help_request_chat_path(@help_request), danger: @message.errors.full_messages.join(", ") }
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

    return if me == owner_id || (helper_id.present? && me == helper_id)

    redirect_to help_requests_tasks_path, danger: "権限がありません"
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
