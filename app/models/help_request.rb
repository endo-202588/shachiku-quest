class HelpRequest < ApplicationRecord
  belongs_to :task
  belongs_to :helper, class_name: 'User', foreign_key: 'helper_id', optional: true
  belongs_to :last_helper, class_name: "User", optional: true
  has_many :help_request_messages, dependent: :destroy

  scope :yesterday_or_before, ->(time) { where("help_requests.updated_at < ?", time.beginning_of_day) }
  scope :matched_only, -> { where(status: :matched) }

  validates :required_time, presence: true, if: -> { task&.help_request? }
  validates :virtue_points,
    presence: true,
    numericality: { only_integer: true, greater_than: 0 },
    if: -> { task&.help_request? }
  validates :status, presence: true
  validates :helper, presence: true, if: -> { matched? || completed? }

  after_update :add_points_to_helper, if: :saved_change_to_status?
  after_commit :notify_matched, on: [:create, :update]

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
        .where(completed_notified_at: nil)
        .find_each(&:reset_to_open!)

      HelpMagic.where("available_date < ?", today).delete_all
    end
  end

  def reset_to_open!
    prev_helper_id = helper_id

    attrs = {
      status: :open,
      last_helper_id: prev_helper_id,
      helper_id: nil,
      matched_on: nil,
      completed_notified_at: nil,
      matched_notified_at: nil
    }

    attrs[:completed_read_at] = nil if has_attribute?(:completed_read_at)
    attrs[:helper_message]    = nil if has_attribute?(:helper_message)

    update!(attrs)
  end

  def cancel_due_to_task_change!
    prev_helper_id = helper_id

    attrs = {
      status: :cancelled,
      last_helper_id: prev_helper_id.presence || last_helper_id,
      helper_id: nil,
      matched_on: nil,
      completed_notified_at: nil
    }

    attrs[:completed_read_at] = nil if has_attribute?(:completed_read_at)
    attrs[:helper_message]    = nil if has_attribute?(:helper_message)

    update!(attrs)
  end

  private

  def add_points_to_helper
    return unless completed?

    helper&.increment!(:total_virtue_points, virtue_points.to_i)
  end

  def notify_matched
    return unless saved_change_to_status?
    return unless matched?

    # 必須情報
    return if helper_id.blank? || task_id.blank?

    # 送信済みなら送らない（※openに戻すとnilになる想定）
    return if matched_notified_at.present?

    # 先に刻印（競合対策）
    update_column(:matched_notified_at, Time.current)

    owner = task.user
    helper = self.helper
    return if owner.nil? || helper.nil?

    body = "マッチが成立しました。アプリ内で連絡してください。"

    # 依頼主宛
    HelpRequestMessage.create!(
      help_request: self,
      sender: nil,          # システム
      recipient: owner,
      message_type: :matched,
      body: body
    )

    # ヘルパー宛
    HelpRequestMessage.create!(
      help_request: self,
      sender: nil,          # システム
      recipient: helper,
      message_type: :matched,
      body: body
    )
  end
end
