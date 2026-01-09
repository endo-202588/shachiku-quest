class Task < ApplicationRecord
  belongs_to :user

  enum status: {
    todo: 0,
    in_progress: 1,
    help_requested: 2,
    help_matched: 3,
    completed: 4
  }

  enum required_time: {
    half_hour: 0,
    one_hour: 1,
    two_hours: 2
  }

  validates :title, presence: true
  validates :status, presence: true
  validates :required_time, presence: true
end
