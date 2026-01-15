class HelpRequest < ApplicationRecord
  belongs_to :task
  belongs_to :helper, optional: true

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

  validates :required_time, presence: true
  validates :status, presence: true
end
