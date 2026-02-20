class HelpRequestDecorator < Draper::Decorator
  delegate_all

  # ステータスバッジ
  def status_badge
    case object.status
    when "open"
      h.content_tag(:span, "オープン", class: "px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm")
    when "matched"
      h.content_tag(:span, "マッチング済み", class: "px-3 py-1 bg-green-100 text-green-800 rounded-full text-sm")
    when "completed"
      h.content_tag(:span, "完了", class: "px-3 py-1 bg-gray-100 text-gray-800 rounded-full text-sm")
    when "cancelled"
      h.content_tag(:span, "キャンセル", class: "px-3 py-1 bg-gray-100 text-gray-800 rounded-full text-sm")
    end
  end

  # 必要時間の表示
  def required_time_display
    h.content_tag(:span, object.required_time_i18n, class: "font-semibold text-gray-700")
  end

  # ヘルパー名の表示
  def helper_name
    return h.content_tag(:span, "未設定", class: "text-gray-400") unless object.helper.present?

    object.helper.decorate.full_name
  end

  def message_or_none(value)
    return h.content_tag(:span, "なし", class: "text-gray-400") unless value.present?
    h.simple_format(h.h(value))
  end

  def request_message
    message_or_none(object.request_message)
  end

  def helper_message
    message_or_none(object.helper_message)
  end

  # ステータス変更ボタン（タスク所有者のみ）
  def status_change_buttons(current_user)
    return unless can_change_status?(current_user)

    h.content_tag(:div, class: "mt-4 space-y-2") do
      h.concat(h.content_tag(:div, "ステータスを変更", class: "text-sm text-gray-600 mb-2"))
      h.concat(render_button_group)
    end
  end

  private

  def can_change_status?(current_user)
    object.task.user == current_user
  end

  def render_button_group
    h.content_tag(:div, class: "flex gap-2 flex-wrap") do
      case object.status
      when "open"
        h.concat(matched_button)
      when "matched"
        h.concat(completed_button)
        h.concat(open_button)
      when "completed"
        h.concat(open_button)
      end
    end
  end

  def matched_button
    h.button_to("マッチング済みにする",
      h.update_status_help_request_path(object, status: :matched),
      method: :patch,
      class: "px-4 py-2 bg-yellow-500 text-white rounded hover:bg-yellow-600 transition text-sm")
  end

  def completed_button
    h.button_to("完了にする",
      h.update_status_help_request_path(object, status: :completed),
      method: :patch,
      class: "px-4 py-2 bg-gray-500 text-white rounded hover:bg-gray-600 transition text-sm",
      data: { turbo_confirm: "本当に完了にしますか?" })
  end

  def cancelled_button
    h.button_to("ヘルプ要請をキャンセルする",
      h.update_status_help_request_path(object, status: :cancelled),
      method: :patch,
      class: "px-4 py-2 bg-gray-500 text-white rounded hover:bg-gray-600 transition text-sm",
      data: { turbo_confirm: "本当にキャンセルしますか?" })
  end

  def open_button
    h.button_to("オープンに戻す",
      h.update_status_help_request_path(object, status: :open),
      method: :patch,
      class: "px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 transition text-sm")
  end
end
