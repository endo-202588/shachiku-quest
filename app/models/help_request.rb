class HelpRequest < ApplicationRecord
  belongs_to :task
  belongs_to :helper, class_name: 'User', foreign_key: 'helper_id'

  validates :required_time, presence: true
  validates :status, presence: true
  validates :helper, presence: true, if: :matched?

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
end
