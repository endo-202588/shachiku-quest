class HelpRequestMessagesController < ApplicationController
  before_action :require_login

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
end
