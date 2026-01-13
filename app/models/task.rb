class Task < ApplicationRecord
  belongs_to :user
  has_one :help_request

  enum :status, {
    todo: 0,
    in_progress: 1,
    help_requested: 2,
    help_matched: 3,
    completed: 4
  }

  scope :by_status, ->(status) { where(status: status) if status.present? }

  validates :title, presence: true
  validates :status, presence: true

  # help_requestedになる際にhelp_requestレコードの作成を確認
  validate :help_request_exists_when_help_requested

  private

  def help_request_exists_when_help_requested
    if help_requested? && help_request.blank?
      errors.add(:base, "ヘルプ要請にはhelp_requestが必要です")
    end
  end
end
