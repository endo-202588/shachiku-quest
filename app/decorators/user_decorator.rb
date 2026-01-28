class UserDecorator < Draper::Decorator
  delegate_all

  # ステータスの色定義
  STATUS_COLORS = {
    'peaceful' => 'bg-green-100 text-green-800',
    'tired' => 'bg-yellow-100 text-yellow-800',
    'busy' => 'bg-orange-100 text-orange-800',
    'very_busy' => 'bg-red-100 text-red-800',
    'overloaded' => 'bg-purple-100 text-purple-800',
    'day_off' => 'bg-blue-100 text-blue-800'
  }.freeze

  # =====================================
  # ユーザー基本情報
  # =====================================

  def full_name
    "#{object.last_name} #{object.first_name}"
  end

  def display_department
    object.department.presence || "未設定"
  end

  # =====================================
  # Help!バッジ（カード右上用）
  # =====================================

  # Help!バッジの表示判定と生成
  def help_badge_html
    open_help_requests = help_request_tasks.select { |t| t.help_request&.open? }
    return nil if open_help_requests.empty?

    count = open_help_requests.size

    h.content_tag(
      :span,
      "Help! (#{count})",
      class: "px-3 py-1 text-xs rounded-full bg-red-600 text-white font-bold shadow-lg animate-pulse",
      title: "ヘルプが必要なタスク: #{count}件"
    )
  end

  # =====================================
  # レベル、total_virtue_points表示
  # =====================================

  def virtue_rank
    case object.total_virtue_points
    when 0..99
      "旅人"
    when 100..299
      "先輩"
    when 300..599
      "達人"
    when 600..999
      "仙人"
    else
      "仏"
    end
  end

  def virtue_rank_badge
    h.content_tag(
      :span,
      'Lv.' + virtue_rank,
      class: "text-xs font-bold bg-indigo-100 text-indigo-800 px-2 py-1 rounded-full"
    )
  end

  def total_virtue_points_badge
    h.content_tag(:span, "Vp.#{object.total_virtue_points}",
      class: "text-xs font-bold bg-yellow-100 text-yellow-800 px-2 py-1 rounded-full"
    )
  end

  # =====================================
  # ステータス表示
  # =====================================

  # シンプルなステータス表示
  def status_display
    if today_status.present?
      today_status.status_label
    else
      "未登録"
    end
  end

  # 絵文字付きステータス表示
  def status_with_emoji
    return "📝 未登録" if today_status.blank?
    # I18n.t("activerecord.enums.status.status_type.#{today_status.status_type}")
    today_status.status_type_i18n
  end

  # HTMLバッジ付きステータス表示（Tailwind CSS版）
  def status_badge_html
    if today_status.blank?
      h.content_tag(:span, "未登録", class: "px-3 py-1 text-sm rounded-full bg-gray-200 text-gray-700")
    else
      # 定数から色を取得(デフォルト値も設定)
      color_class = STATUS_COLORS[today_status.status_type] || "bg-gray-100 text-gray-800"

      h.content_tag(:span, status_with_emoji, class: "px-3 py-1 text-sm rounded-full #{color_class}")
    end
  end

  # 今日のステータスのメモを取得
  def today_status_memo
    today_status&.memo&.presence || '未設定'
  end

  # メモが存在するかチェック
  def today_status_memo?
    today_status&.memo&.presence.present?
  end

  # メモのHTMLバッジを返す
  def status_memo_html
    return nil unless today_status_memo?

    h.content_tag(:div, class: "mt-2 p-2 bg-gray-50 rounded border border-gray-200") do
      h.content_tag(:p, class: "text-xs text-gray-700") do
        h.concat h.content_tag(:span, "📝 メモ: ", class: "font-medium")
        h.concat today_status_memo
      end
    end
  end

  # ★ ステータスセクション全体を生成
  def status_section_html(current_user)
    h.content_tag(:div, class: "mt-4 pt-4 border-t border-gray-200") do
      h.safe_join([
        status_label_and_badge_html,
        hp_display_html,
        status_memo_html,
        status_action_buttons_html(current_user)
      ])
    end
  end

  def status_edit_button_html
    return unless today_status

    h.link_to h.edit_status_path(today_status),
      class: 'text-gray-500 text-xs hover:text-gray-900 px-2 py-1 rounded transition inline-flex items-center justify-center' do
      h.raw <<~HTML
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
        <path stroke-linecap="round" stroke-linejoin="round" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
      </svg>
      HTML
    end
  end

  def status_reset_button_html
    return unless today_status

      h.button_to h.status_path(today_status),
      method: :delete,
      data: { turbo_method: :delete, turbo_confirm: '本当にリセットしますか?' },
      class: 'text-gray-500 text-xs hover:text-gray-900 px-2 py-1 rounded transition inline-flex items-center justify-center' do

      h.raw <<~HTML
        <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
            d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
        </svg>
      HTML
    end
  end

  # =====================================
  # HP表示
  # =====================================

  # HP数字表示（ドラクエ風）
  def hp_text_html
    return h.content_tag(:span, "HP: ???/???", class: "text-sm text-gray-500") if today_status.blank?

    hp = today_status.hp
    max_hp = today_status.max_hp

    # HPの割合で色を変える
    text_color = if hp >= 70
                   "text-green-600"
                 elsif hp >= 40
                   "text-yellow-600"
                 else
                   "text-red-600"
                 end

    h.content_tag(:div, class: "flex items-center gap-2") do
      heart_svg = <<~SVG
        <svg xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
            fill="currentColor"
            class="w-5 h-5 block text-red-500">
          <path d="m9.653 16.915-.005-.003-.019-.01a20.759 20.759 0 0 1-1.162-.682 22.045 22.045 0 0 1-2.582-1.9C4.045 12.733 2 10.352 2 7.5a4.5 4.5 0 0 1 8-2.828A4.5 4.5 0 0 1 18 7.5c0 2.852-2.044 5.233-3.885 6.82a22.049 22.049 0 0 1-3.744 2.582l-.019.01-.005.003h-.002a.739.739 0 0 1-.69.001l-.002-.001Z" />
        </svg>
      SVG

      h.concat h.raw(heart_svg)
      h.concat h.content_tag(:span, "HP: #{hp}/#{max_hp}", class: "text-sm font-bold #{text_color}")
    end
  end

  # HPバー表示（プログレスバー）
  def hp_bar_html
    return "" if today_status.blank?

    hp = today_status.hp
    max_hp = today_status.max_hp
    percentage = today_status.hp_percentage

    # HPの割合で色を変える
    bar_color = if percentage >= 70
                  "bg-green-500"
                elsif percentage >= 40
                  "bg-yellow-500"
                else
                  "bg-red-500"
                end

    <<~HTML.html_safe
      <div class="w-full bg-gray-200 rounded-full h-3 overflow-hidden mt-2">
        <div class="#{bar_color} h-3 transition-all duration-300"
             style="width: #{percentage}%">
        </div>
      </div>
    HTML
  end

  # HP表示（数字 + プログレスバー）
  def hp_display_html
    return "" if today_status.blank?

    <<~HTML.html_safe
      <div class="mt-3 p-3 bg-gray-50 rounded-lg border border-gray-200">
        #{hp_text_html}
        #{hp_bar_html}
      </div>
    HTML
  end

  # =====================================
  # タスク表示
  # =====================================

  # 進行中のタスク数のバッジ表示
  def in_progress_tasks_badge
    return nil if in_progress_tasks.empty?

    h.content_tag :span, "#{in_progress_tasks.size}件",
      class: 'text-xs bg-indigo-100 text-indigo-800 px-2 py-1 rounded-full'
  end

  # 進行中のタスクセクション全体
  def in_progress_tasks_section(current_user)
    return nil if in_progress_tasks.empty?

    h.content_tag :div, class: 'mt-4 pt-4 border-t border-gray-200' do
      h.concat in_progress_tasks_header
      h.concat in_progress_tasks_list(current_user)
    end
  end

  # タスク一覧リンク(自分のカードの場合のみ表示)
  def tasks_index_link
    return nil unless h.current_user == object

    h.content_tag :div, class: 'mt-3' do
      h.link_to '▶︎ タスク一覧を見る', h.tasks_path,
        class: 'bg-indigo-500 hover:bg-indigo-600 text-white font-bold py-2 px-4 rounded text-sm block text-center w-full'
    end
  end

  # =====================================
  # help_magic表示
  # =====================================

  def available_time_with_icon
    return nil unless help_magic&.available_time  # 直接アクセス可能

    h.content_tag :span, class: 'flex items-center gap-1' do
      h.concat h.content_tag(:span, '⏰')
      h.concat help_magic.available_time_i18n
    end
  end

  # =====================================
  # シャチークの給湯室
  # =====================================

  # ヘルパーがヘルプ中かどうかの判定
  def helping_now?
    object.helper? && object.received_help_requests.exists?(status: :matched)
  end



  private

  # -------------------------------------
  # ステータス表示 - private
  # -------------------------------------

  # ステータスラベルとバッジ
  def status_label_and_badge_html
    h.content_tag(:div, class: "flex items-center justify-between") do
      h.concat(h.content_tag(:span, "今日のステータス:", class: "text-sm font-medium text-gray-600"))
      h.concat(status_badge_html)
    end
  end

  # 編集・リセットボタン(自分のステータスのみ)
  def status_action_buttons_html(current_user)
    return "" unless current_user == object

    h.content_tag(:div, class: "flex gap-2 mt-3") do
      h.concat(status_edit_button_html)
      h.concat(status_reset_button_html)
    end
  end

  # -------------------------------------
  # タスク表示 - private
  # -------------------------------------

  # タスクセクションのヘッダー
  def in_progress_tasks_header
    h.content_tag :div, class: 'flex items-center justify-between mb-2' do
      h.concat h.content_tag(:span, '📋 本日のタスク:', class: 'text-sm font-medium text-gray-600')
      h.concat in_progress_tasks_badge
    end
  end

  # タスクリスト
  def in_progress_tasks_list(current_user)
    h.content_tag :ol, class: 'list-decimal list-inside space-y-1 text-sm text-gray-700' do
      in_progress_tasks.each do |task|
        h.concat task.decorate.list_item_with_actions(current_user, object)
      end
    end
  end
end
