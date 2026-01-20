class Task < ApplicationRecord
  belongs_to :user
  has_one :help_request, dependent: :destroy
  has_one :helper, through: :help_request, source: :helper

  enum status: {
    in_progress: 0,
    help_request: 1,
    complete: 2
  }

  scope :by_status, ->(status) { where(status: status) if status.present? }

  validates :title, presence: true
  validates :status, presence: true

  # ヘルプ要請タスクの場合、help_requestが必要
  validate :help_request_presence, if: -> { status == 'help_request' }
  # ヘルプ要請タスクの場合、required_timeが選択されている必要がある
  validate :required_time_presence, if: -> { status == 'help_request' }

  private

  def help_request_presence
    # help_request関連レコードの存在をチェック
    if help_request.blank?
      errors.add(:base, "ヘルプ要請にはhelp_requestが必要です")
    end
  end

  def required_time_presence
    # help_requestが存在し、required_timeが空の場合にエラーを追加
    if help_request.present? && help_request.required_time.blank?
      errors.add(:base, '必要な時間を選択してください')
    end
  end
end
