class StatusesController < ApplicationController
  before_action :require_login
  before_action :set_status, only: [:edit, :update, :destroy]

  def new
    @target_date = parse_date_param || Date.today

    # kept を追加して削除されていないレコードのみ取得
    existing_status = current_user.statuses.kept.find_by(status_date: @target_date)

    if existing_status
      redirect_to edit_status_path(existing_status, date: @target_date)
      return
    end

    @status = current_user.statuses.build(status_date: @target_date)
  end

  def create
    @status = current_user.statuses.build(status_params)

    if @status.save
      # ========== 履歴を記録(新規作成時) ========== #
      @status.status_histories.create!(
        old_status_type: nil,
        new_status_type: @status.status_type,
        changed_at: Time.current,
        user: current_user,
        comment: "新規作成"
      )

      # determine_redirect_after_saveメソッドを使用
      redirect_path, message = determine_redirect_after_save(@status, 'を登録しました')
      redirect_to redirect_path, success: message
    else
      @target_date = @status.status_date
      flash.now[:danger] = 'ステータスの登録に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @target_date = @status.status_date

    # 履歴を新しい順に取得(最新5件のみ表示)
    @status_histories = @status.status_histories.order(created_at: :desc).limit(5)
  end

  def update
    # ========== 更新前の状態を保存 ========== #
    previous_state = @status.status_type

    if @status.update(status_params)
      # ========== 履歴を記録(更新時) ========== #
      # ステータスが変更された場合のみ履歴を記録
      if previous_state != @status.status_type
        @status.status_histories.create!(
          old_status_type: previous_state,
          new_status_type: @status.status_type,
          changed_at: Time.current,
          user: current_user,
          comment: nil
        )
      end

      # ========== 更新時は常にusers_pathへリダイレクト ========== #
      date_text = @status.status_date.strftime('%Y年%m月%d日')
      redirect_to users_path, success: "#{date_text}のステータスを更新しました"
    else
      @target_date = @status.status_date
      @status_histories = @status.status_histories.order(created_at: :desc).limit(5)
      flash.now[:danger] = 'ステータスの更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @status.destroy!
    redirect_to users_path, success: "ステータスをリセットしました", status: :see_other
  rescue ActiveRecord::RecordNotDestroyed => e
    redirect_to users_path, danger: "ステータスの削除に失敗しました", status: :see_other
  end

  private

  def set_status
    @status = current_user.statuses.find(params[:id])
  end

  def status_params
    params.require(:status).permit(:status_type, :status_date, :memo)
  end

  # リダイレクト先とメッセージを決定するヘルパーメソッド(新規登録用)
  def determine_redirect_after_save(status, action_text)
    date_text = status.status_date.strftime('%Y年%m月%d日')

    if status.status_date == Date.today
      # 今日のステータスを登録した場合
      [users_path, "#{date_text}のステータス#{action_text}"]  # ← インデントを揃える
    else
      # 未来や過去のステータスを登録した場合
      message = "#{date_text}のステータス#{action_text}"
      message += "。本日のステータスも登録しましょう!"
      [new_status_path, message]
    end
  end

  # 日付パラメータを安全にパース
  def parse_date_param
    return nil unless params[:date].present?

    Date.parse(params[:date])
  rescue ArgumentError, TypeError
    nil  # 不正な日付の場合はnilを返す
  end
end
