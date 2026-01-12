class Status < ApplicationRecord
  belongs_to :user

  # HP値の定義
  HP_VALUES = {
    peaceful: 100,
    tired: 70,
    busy: 50,
    very_busy: 30,
    overloaded: 10,
    day_off: 100
  }.freeze

  enum status_type: {
    peaceful: 0,
    tired: 1,
    busy: 2,
    very_busy: 3,
    overloaded: 4,
    day_off: 5
  }

  validates :status_type, presence: true
  validates :status_date,
    presence: true,
    uniqueness: { scope: :user_id }

  # ステータスの日本語表示（推奨）
  def status_label
    Status.human_attribute_name("status_type.#{status_type}")
  end

  # 出勤しているか判定
  def working?
    !day_off?
  end

  # HPを返すメソッド
  def hp
    HP_VALUES[status_type.to_sym] || 0
  end

  # 最大HPを返すメソッド
  def max_hp
    100
  end

  # HP割合を返すメソッド（プログレスバー用）
  def hp_percentage
    return 0 if max_hp.zero?
    (hp.to_f / max_hp * 100).round
  end
end
