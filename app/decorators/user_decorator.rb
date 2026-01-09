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
    I18n.t("enums.status.status_type.#{today_status.status_type}")
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
      h.concat h.content_tag(:span, "❤️", class: "text-lg")
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
end
