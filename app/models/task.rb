class Task < ApplicationRecord
  belongs_to :user
  has_one :help_request, dependent: :destroy
  has_one :helper, through: :help_request, source: :helper
  accepts_nested_attributes_for :help_request, update_only: true

  enum status: {
    in_progress: 0,
    help_request: 1,
    complete: 2
  }

  after_update :close_help_request_if_task_not_help_request

  scope :by_status, ->(status) { status.present? ? where(status:) : all }

  validates :title, presence: true
  validates :status, presence: true

  validates :help_request, presence: true, if: :help_request?
  validates_associated :help_request, if: :help_request?

  private

  def close_help_request_if_task_not_help_request
    return unless saved_change_to_status?
    return if help_request?
    return if help_request.blank?

    help_request.update_columns(
      status: HelpRequest.statuses[:cancelled],
      updated_at: Time.current
    )
  end
end
