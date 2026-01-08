class StatusHistory < ApplicationRecord
  belongs_to :status
  belongs_to :user

  # 既存のStatusモデルと同じenumを定義
  enum old_status_type: {
    peaceful: 0,
    tired: 1,
    busy: 2,
    very_busy: 3,
    overloaded: 4,
    day_off: 10
  }, _prefix: true

  enum new_status_type: {
    peaceful: 0,
    tired: 1,
    busy: 2,
    very_busy: 3,
    overloaded: 4,
    day_off: 10
  }, _prefix: true

  validates :changed_at, presence: true
end
