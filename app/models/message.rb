class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :sender, class_name: "User", optional: true

  enum :message_type, {
    user: 0,
    system: 1
  }

  enum :event_type, {
    matched: 0,
    completed: 1,
    closed: 2
  }, prefix: true

  validates :body, presence: true
  validate :sender_required_for_user_message

  private

  def sender_required_for_user_message
    return unless user?
    errors.add(:sender, "must exist for user messages") if sender.nil?
  end
end
