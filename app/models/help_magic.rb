class HelpMagic < ApplicationRecord
  belongs_to :user

  enum :available_time, {
    half_hour: 0,
    one_hour: 1,
    one_and_half_hours: 2,
    two_hours: 3,
    long_time: 4
  }

  validates :available_time, presence: true
  validates :available_date, presence: true
end
