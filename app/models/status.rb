class Status < ApplicationRecord
  belongs_to :user
  has_many :status_histories, dependent: :destroy
  include Discard::Model

  # ステータスが変更された時に履歴を記録
  after_update :record_history, if: :saved_change_to_status_type?

  enum status_type: {
    peaceful: 0,
    tired: 1,
    busy: 2,
    very_busy: 3,
    overloaded: 4,
    day_off: 10
  }

  validates :status_type, presence: true
  validates :status_date, presence: true, uniqueness: { scope: :user_id }

  # ステータスの日本語表示（推奨）
  def status_label
    Status.human_attribute_name("status_type.#{status_type}")
  end

  # 出勤しているか判定
  def working?
    !day_off?
  end

  # 編集回数を取得
  def edit_count
    status_histories.count
  end

  private

  def record_history
    status_histories.create!(
      user: user,
      old_status_type: status_type_previously_was,
      new_status_type: status_type,
      changed_at: Time.current
    )
  end
end
