class TaskDecorator < Draper::Decorator
  delegate_all

  # =====================================
  # ステータス表示
  # =====================================

  # ステータスの色定義
  STATUS_COLORS = {
    'in_progress' => 'bg-blue-100 text-blue-800',           # 自分で行うタスク
    'help_request' => 'bg-yellow-100 text-yellow-800' # ヘルプ要請タスク
  }.freeze

  # ステータスバッジ
  def status_badge_html
    color_class = STATUS_COLORS[object.status] || "bg-gray-100 text-gray-800"
    h.content_tag(:span, status_text, class: "px-3 py-1 text-sm rounded-full #{color_class}")
  end

  # ステータスのテキスト
  def status_text
    I18n.t("activerecord.enums.task.status.#{status}")
  end

  # =====================================
  # タスクリスト表示
  # =====================================

  # タスクのリスト項目(アクションボタン付き)
  def list_item_with_actions(current_user, task_owner)
    h.content_tag :li, class: 'flex items-center justify-between gap-2' do
      h.concat task_title_span
      h.concat action_buttons(current_user, task_owner) if show_actions?(current_user, task_owner)
    end
  end

  # タスクタイトル
  def task_title_span
    h.content_tag :span, title, class: 'truncate flex-1'
  end

  # アクションボタンを表示するか判定
  def show_actions?(current_user, task_owner)
    current_user == task_owner
  end

  # 編集・削除ボタン
  def action_buttons(current_user, task_owner)
    return nil unless show_actions?(current_user, task_owner)

    h.content_tag :div, class: 'flex gap-1' do
      h.concat edit_button
      h.concat delete_button
    end
  end

  # 編集ボタン
  def edit_button
    h.link_to h.edit_task_path(object),
      class: 'text-xs bg-yellow-500 hover:bg-yellow-600 text-white px-2 py-1 rounded transition' do
      '✏️ 編集'
    end
  end

  # 削除ボタン
  def delete_button
    h.link_to h.task_path(object),
      data: { turbo_method: :delete, turbo_confirm: '本当に削除しますか?' },
      class: 'text-xs bg-red-500 hover:bg-red-600 text-white px-2 py-1 rounded transition' do
      '🗑️ 削除'
    end
  end

  # =====================================
  # ヘルプ要請関連
  # =====================================

  # 必要時間のテキスト
  def required_time_text
    return nil unless help_request?
    return nil unless object.help_request&.required_time
    I18n.t("activerecord.enums.help_request.required_time.#{object.help_request.required_time}")
  end

  # 必要時間のアイコン付きテキスト
  def required_time_with_icon
    return nil unless help_request?
    return nil unless object.help_request&.required_time
    h.content_tag :span, class: 'flex items-center gap-1' do
      h.concat h.content_tag(:span, '⏰')
      h.concat required_time_text
    end
  end
end
