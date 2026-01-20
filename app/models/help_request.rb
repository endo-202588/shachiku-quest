class HelpRequest < ApplicationRecord
  belongs_to :task
  belongs_to :helper, class_name: 'User', foreign_key: 'helper_id', optional: true

  validates :required_time, presence: true
  validates :status, presence: true
  validates :helper, presence: true, if: :matched?

  before_update :clear_helper_if_open

  enum :status, {
    open: 0,
    matched: 1,
    closed: 2
  }

  enum :required_time, {
    half_hour: 0,
    one_hour: 1,
    one_and_half_hours: 2,
    two_hours: 3,
    long_time: 4
  }

  def matched?
    status == 'matched'
  end

  private
  
  def clear_helper_if_open
    if will_save_change_to_status? && status == "open"
      self.helper_id = nil
    end
  end
end
