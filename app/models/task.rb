class Task < ApplicationRecord
  belongs_to :user
  has_one :help_request, dependent: :destroy
  has_one :helper, through: :help_request, source: :helper
  accepts_nested_attributes_for :help_request, update_only: true

  enum :status, {
    in_progress: 0,
    help_request: 1,
    complete: 2
  }

  after_update :cancel_help_request_if_task_no_longer_help_request, if: :saved_change_to_status?

  scope :by_status, ->(status) { status.present? ? where(status:) : all }

  validates :title, presence: true
  validates :status, presence: true

  validates :help_request, presence: true, if: :help_request?
  validates_associated :help_request, if: :help_request?

  def self.ransackable_attributes(auth_object = nil)
    %w[user_id title description]
  end

    def self.ransackable_associations(auth_object = nil)
    %w[user]
  end

  private

  def cancel_help_request_if_task_no_longer_help_request
    return if help_request?       # status が help_request のままなら何もしない
    return if help_request.blank? # 紐づきがなければ何もしない

    help_request.cancel_due_to_task_change!
  end
end
