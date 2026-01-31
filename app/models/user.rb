class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :statuses, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :in_progress_tasks, -> { where(status: 'in_progress') }, class_name: 'Task'
  has_many :help_request_tasks, -> { where(status: 'help_request') }, class_name: 'Task'
  has_one :help_magic, dependent: :destroy
  has_many :received_help_requests,
         class_name: 'HelpRequest',
         foreign_key: 'helper_id',
         dependent: :nullify
  has_many :help_requests, through: :tasks
  has_one_attached :avatar
  has_many :user_personality_tags, dependent: :destroy
  has_many :personality_tags, through: :user_personality_tags

  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name, presence: true, length: { maximum: 255 }
  validates :department, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :last_name_kana, :first_name_kana,
          presence: true,
          format: { with: /\A[ぁ-んー]+\z/, message: "はひらがなで入力してください" }

  enum :role, { general: 0, admin: 1, manager: 2 }

  def admin?
    role == "admin"
  end

  # 本日のステータスを取得(ビュー用 - includes済みの場合に効率的)
  def today_status
    # N+1回避: includes済みのstatusesからメモリ上で検索
    # ビューで複数回呼ばれてもSQLは発行されない
    statuses.to_a.find { |status| status.status_date == Date.current }
  end

  # 本日のステータスが存在するかチェック(コントローラー用 - 軽量)
  def has_today_status?
    statuses.exists?(status_date: Date.current)
  end

  def invalidate_help_magic_if_expired!
    hm = help_magic
    return unless hm
    return if hm.available_date >= Date.current

    hm.destroy!
  end

  # ヘルパーとして登録されているかチェック
  def helper?
    hm = help_magic
    hm&.available_date.present? && hm.available_date >= Date.current
  end

  def helping_now?
    HelpRequest.exists?(helper_id: id, status: :matched)
  end

  def can_delete_help_magic?
    helper? && !helping_now?
  end
end
