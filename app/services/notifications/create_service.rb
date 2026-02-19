module Notifications
  class CreateService
    def self.call!(help_request:, recipient:, message_type:, body:, sender: nil)
      Notification.create!(
        help_request: help_request,
        recipient: recipient,
        sender: sender,
        message_type: message_type,
        body: body
      )
    end
  end
end
