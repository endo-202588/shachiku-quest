class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :statuses, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :in_progress_tasks, -> { where(status: 'in_progress') }, class_name: 'Task'
  has_many :help_requested_tasks, -> { where(status: 'help_request') }, class_name: 'Task'
  has_one :help_magic, dependent: :destroy
  has_many :received_help_requests,
         class_name: 'HelpRequest',
         foreign_key: 'helper_id',
         dependent: :nullify

  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name, presence: true, length: { maximum: 255 }
  validates :department, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

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

  # ヘルパーとして登録されているかチェック
  def helper?
    help_magics.where('available_date >= ?', Date.today).exists?
  end
end
