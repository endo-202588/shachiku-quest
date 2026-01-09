class StatusesController < ApplicationController
  before_action :require_login
  before_action :set_status, only: [:edit, :update, :destroy]

  def new
    @target_date = parse_date_param || Date.today

    # 既存のステータスがあればそれを使い、なければ新規作成
    @status = current_user.statuses.kept.find_or_initialize_by(status_date: @target_date)

    # 既存のステータスがある場合はフラッシュメッセージを表示
    if @status.persisted?
      flash.now[:notice] = "#{@target_date.strftime('%Y年%m月%d日')}のステータスは既に登録されています。内容を確認・編集できます。"
    end
  end

  # def new_schedule
  #   @target_date = parse_date_param || Date.tomorrow

  #   # 当日は選択できないようにする
  #   if @target_date == Date.today
  #     redirect_to new_status_path, alert: '本日のステータスは通常の登録画面から行ってください'
  #     return
  #   end

  #   # 既存のステータスがあれば編集画面へ
  #   existing_status = current_user.statuses.kept.find_by(status_date: @target_date)

  #   if existing_status
  #     redirect_to edit_status_path(existing_status, date: @target_date)
  #     return
  #   end

  #   @status = current_user.statuses.build(status_date: @target_date)
  #   render :new_schedule
  # end

  def new_schedule
    # 日付選択画面を表示するだけ
  end

  def create_schedule
    Rails.logger.debug "====== デバッグ情報(create_schedule) ======"
    Rails.logger.debug "params: #{params.inspect}"

    selected_date = params[:status_date]

    Rails.logger.debug "selected_date: #{selected_date.inspect}"
    Rails.logger.debug "============================================="

    if selected_date.blank?
      redirect_to new_schedule_statuses_path, alert: '日付を選択してください'
      return
    end

    @status = current_user.statuses.find_or_initialize_by(status_date: selected_date)

    Rails.logger.debug "@status.persisted?: #{@status.persisted?}"
    Rails.logger.debug "@status.attributes: #{@status.attributes.inspect}"

    respond_to do |format|
      if @status.persisted?
        format.html { redirect_to edit_status_path(@status) }
        format.turbo_stream { redirect_to edit_status_path(@status) }
      else
        format.html { render :new }
        format.turbo_stream { render :new }
      end
    end
  end

  def create
    @status = current_user.statuses.build(status_params)

    if @status.save
      # 履歴を記録
      @status.status_histories.create!(
        old_status_type: nil,
        new_status_type: @status.status_type,
        changed_at: Time.current,
        user: current_user,
        comment: "新規作成"
      )

      # リダイレクト先を決定
      redirect_path, message = determine_redirect_after_save(@status, 'を登録しました')
      redirect_to redirect_path, success: message
    else
      @target_date = @status.status_date
      flash.now[:danger] = 'ステータスの登録に失敗しました'
    
      # 当日以外のステータス登録の場合は new_schedule をレンダリング
      if @status.status_date != Date.today
        render :new_schedule, status: :unprocessable_entity
      else
        render :new, status: :unprocessable_entity
      end
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
