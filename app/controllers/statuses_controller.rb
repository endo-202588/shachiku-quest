class StatusesController < ApplicationController
  before_action :set_status, only: [:edit, :update, :destroy]

  # ステータス登録関連のアクションでは本日のステータスチェックをスキップ
  skip_before_action :check_today_status, only: [:index, :new, :create, :new_schedule, :create_schedule, :complete, :edit, :update]

  def index
    base = current_user.statuses.order(status_date: :desc)

    if params[:month].present?
      @month = Date.parse("#{params[:month]}-01")
      range  = @month..@month.end_of_month
      @statuses = base.where(status_date: range).page(params[:page]).per(10)
    else
      @month = Date.current.beginning_of_month
      @statuses = base.limit(30)
    end
  end

  def new
    @target_date = parse_iso_date(params[:date]) || Date.current

    # 既存のステータスがあればそれを使い、なければ新規作成
    @status = current_user.statuses.find_or_initialize_by(status_date: @target_date)

    # 既存のステータスがある場合はフラッシュメッセージを表示
    if @status.persisted?
      flash.now[:danger] = "#{@target_date.strftime('%Y年%m月%d日')}のステータスは既に登録されています。内容を確認・編集できます。"
    end
  end

  def new_schedule
    # 日付選択画面を表示するだけ
  end

  def create_schedule
    selected_date = parse_iso_date(params[:status_date])

    unless selected_date
      redirect_to new_schedule_statuses_path, danger: '日付を選択してください'
      return
    end

    @target_date = selected_date
    @status = current_user.statuses.find_or_initialize_by(status_date: @target_date)

    if @status.persisted?
      # 既存のステータスがある場合は編集画面へ
      redirect_to edit_status_path(@status)
    else
      # 新規作成の場合は登録画面へ
      redirect_to new_status_path(date: selected_date.iso8601)
    end
  end

  def create
    @status = current_user.statuses.build(status_params)

    if @status.save
      redirect_path, message = determine_redirect_after_save(@status)
      redirect_to redirect_path, success: message
    else
      @target_date = @status.status_date
      flash.now[:danger] = 'ステータスの登録に失敗しました'

      if @status.status_date != Date.today
        render :new_schedule, status: :unprocessable_entity
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def complete
    @status = current_user.statuses.find(params[:status_id])
  end

  def edit
    @target_date = @status.status_date
  end

  def update
    if @status.update(status_params)
      date_text = @status.status_date.strftime('%Y年%m月%d日')
      redirect_back_or_to params[:return_to],
        fallback_location: users_path,
        success: "#{date_text}のステータスを更新しました"
    else
      @target_date = @status.status_date
      flash.now[:danger] = 'ステータスの更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @status.destroy
      redirect_to users_path, success: "ステータスをリセットしました", status: :see_other
    else
      redirect_to users_path, danger: "ステータスのリセットに失敗しました", status: :see_other
    end
  end

  private

  def set_status
    @status = current_user.statuses.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to users_path, danger: "ステータスが見つかりませんでした"
    return
  end

  def status_params
    params.require(:status).permit(:status_type, :status_date, :memo)
  end

  # リダイレクト先とメッセージを決定するヘルパーメソッド(修正版)
  def determine_redirect_after_save(status)
    date_text = status.status_date.strftime('%Y年%m月%d日')

    if status.status_date == Date.current
      # 今日のステータスを登録した場合 → タスク登録へ
      [new_task_path, 'ステータスを登録しました！続けて今日のタスクを登録しましょう🎯']
      # [users_path, 'ステータスを登録しました!']
    else
      # 未来や過去のステータスを登録した場合 → 本日のステータス登録へ
      message = "#{date_text}のステータスを登録しました。本日のステータスも登録しましょう!"
      [new_status_path, message]
    end
  end

  # 日付パラメータを安全にパース
  def parse_iso_date(raw)
    return nil if raw.blank?
    Date.iso8601(raw)
  rescue ArgumentError, TypeError
    nil
  end
end
