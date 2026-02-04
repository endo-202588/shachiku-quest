class HelpRequest < ApplicationRecord
  belongs_to :task
  belongs_to :helper, class_name: 'User', foreign_key: 'helper_id', optional: true
  belongs_to :last_helper, class_name: "User", optional: true

  scope :yesterday_or_before, ->(time) { where("help_requests.updated_at < ?", time.beginning_of_day) }
  scope :matched_only, -> { where(status: :matched) }

  validates :required_time, presence: true
  validates :status, presence: true
  validates :helper, presence: true, if: -> { matched? || completed? }

  before_update :reset_fields_when_status_becomes_open
  after_update :add_points_to_helper, if: :saved_change_to_status?

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

  def self.reset_yesterday_matched_all!(now: Time.zone.now)
    today = now.to_date

    ActiveRecord::Base.transaction do
      matched_only
        .where("matched_on < ?", today)
        .find_each(&:reset_to_open!)

      HelpMagic.where("available_date < ?", today).delete_all
    end
  end

  def reset_to_open!
    prev_helper_id = helper_id

    update!(
      status: :open,
      last_helper_id: prev_helper_id,
      helper_id: nil,
      matched_on: nil,
      completed_notified_at: nil
    )
  end

  private

  def reset_fields_when_status_becomes_open
    return unless will_save_change_to_status?
    return unless open?

    # open に戻る直前の helper を last_helper_id に退避
    self.last_helper_id = helper_id if helper_id.present?

    # open に戻ったら必ずリセット
    self.helper_id = nil
    self.completed_notified_at = nil
    self.completed_read_at = nil if respond_to?(:completed_read_at)
    self.helper_message = nil if respond_to?(:helper_message)
  end

  def add_points_to_helper
    return unless completed?

    helper&.increment!(:total_virtue_points, virtue_points.to_i)
  end
end
