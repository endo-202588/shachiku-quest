class UserDecorator < Draper::Decorator
  delegate_all

  def full_name
    "#{object.last_name} #{object.first_name}"
  end

  def display_department
    object.department.presence || "未設定"
  end

  # ✅ ステータス表示用メソッドをデコレーターに追加

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

    emoji = case today_status.status_type
            when "peaceful" then "😊"
            when "tired" then "😓"
            when "busy" then "🏃"
            when "very_busy" then "🔥"
            when "overloaded" then "💀"
            when "day_off" then "🏖️"
            else "❓"
            end

    "#{emoji} #{today_status.status_label}"
  end

  # HTMLバッジ付きステータス表示（Tailwind CSS版）
  def status_badge_html
    if today_status.blank?
      h.content_tag(:span, "📝 未登録", class: "px-3 py-1 text-sm rounded-full bg-gray-200 text-gray-700")
    else
      color_class = case today_status.status_type
                    when "peaceful"
                      "bg-green-100 text-green-800"
                    when "tired"
                      "bg-yellow-100 text-yellow-800"
                    when "busy"
                      "bg-orange-100 text-orange-800"
                    when "very_busy"
                      "bg-red-100 text-red-800"
                    when "overloaded"
                      "bg-purple-100 text-purple-800"
                    when "day_off"
                      "bg-blue-100 text-blue-800"
                    else
                      "bg-gray-100 text-gray-800"
                    end

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

  def status_edit_button_html
    return unless today_status

    h.link_to(
    "✏️ 編集",
    h.edit_status_path(today_status),
    class: "inline-block mt-2 px-3 py-1 bg-blue-500 text-white text-sm rounded hover:bg-blue-600 transition"
    )
  end

  def status_reset_button_html
    return unless today_status

    h.link_to(
    "🔄 リセット",
    h.status_path(today_status),
    data: { turbo_method: :delete, turbo_confirm: "本当にリセットしますか?" },
    class: "inline-block mt-2 px-3 py-1 bg-red-500 text-white text-sm rounded hover:bg-red-600 transition"
    )
  end
end
