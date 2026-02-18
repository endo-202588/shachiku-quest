class HelpRequestChat < ApplicationRecord
  belongs_to :help_request
  belongs_to :sender, class_name: "User", optional: true
  belongs_to :recipient, class_name: "User"
  enum :message_type, {
    matched: 0,   # システム→両者
    completed: 1, # ヘルパー→依頼主
    thanks: 2     # 依頼主→ヘルパー
  }

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  validates :message_type, presence: true
  validates :body, presence: true

  def read!
    return if read_at.present?
    update!(read_at: Time.zone.now)
  end

  def message_type_label
    case message_type
    when "matched" then "マッチ成立"
    when "completed" then "完了通知"
    when "thanks" then "サンクスメッセージ"
    else "メッセージ"
    end
  end
end
