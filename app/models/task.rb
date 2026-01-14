class Task < ApplicationRecord
  belongs_to :user
  has_one :help_request, dependent: :destroy
  accepts_nested_attributes_for :help_request

  enum task_type: {
    normal: 0,
    help_request: 1
  }

  scope :by_task_type, ->(task_type) { where(task_type: task_type) if task_type.present? }

  validates :title, presence: true
  validates :task_type, presence: true

  # ヘルプ要請タスクの場合、help_requestが必要
  validate :help_request_presence, if: -> { task_type == 'help_request' }
  # ヘルプ要請タスクの場合、required_timeが選択されている必要がある
  validate :required_time_presence, if: -> { task_type == 'help_request' }

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
