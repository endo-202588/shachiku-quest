class HelpRequest < ApplicationRecord
  belongs_to :task
  belongs_to :helper, class_name: 'User', foreign_key: 'helper_id', optional: true
  belongs_to :last_helper, class_name: "User", optional: true

  validates :required_time, presence: true
  validates :status, presence: true
  validates :helper, presence: true, if: -> { matched? || completed? }

  # before_save :clear_helper_if_open
  before_update :stash_and_clear_helper, if: :should_clear_helper_on_status_change?

  enum :status, {
    open: 0,
    matched: 1,
    completed: 2,
    cancelled: 3
  }

  enum :required_time, {
    half_hour: 0,
    one_hour: 1,
    one_and_half_hours: 2,
    two_hours: 3,
    long_time: 4
  }

  private

  def clear_helper_if_open
    return unless will_save_change_to_status?
    return unless open?

    self.last_helper_id = helper_id if helper_id.present?

    self.helper_id = nil
    self.helper_message = nil
    self.completed_notified_at = nil
    self.completed_read_at = nil
  end

  def ending_status_change?
    will_save_change_to_attribute?(:status) && (completed? || cancelled?)
  end

  def should_clear_helper_on_status_change?
    will_save_change_to_attribute?(:status) && open?
  end
  
  def stash_and_clear_helper
    self.last_helper_id ||= helper_id if helper_id.present?
    self.helper_id = nil
  end
end
