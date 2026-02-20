class UserDecorator < Draper::Decorator
  delegate_all

  # ステータスの色定義
  STATUS_COLORS = {
    "peaceful" => "bg-green-100 text-green-800",
    "tired" => "bg-yellow-100 text-yellow-800",
    "busy" => "bg-orange-100 text-orange-800",
    "very_busy" => "bg-red-100 text-red-800",
    "overloaded" => "bg-purple-100 text-purple-800",
    "day_off" => "bg-blue-100 text-blue-800"
  }.freeze

  # =====================================
  # ユーザー基本情報
  # =====================================

  def full_name
    "#{object.last_name} #{object.first_name}"
  end

  def full_name_kana
    "#{object.last_name_kana} #{object.first_name_kana}"
  end

  def display_department
    object.department.presence || "未設定"
  end

  def avatar_initial
    kana = object.last_name_kana.to_s.strip

    return "?" if kana.empty?

    # カタカナ → ひらがな
    kana = kana.tr("ァ-ヶ", "ぁ-ゖ")

    kana[0]
  end

  require "zlib"

  def avatar_color_class
    palette = %w[
      bg-indigo-200 text-indigo-900
      bg-sky-200 text-sky-900
      bg-emerald-200 text-emerald-900
      bg-amber-200 text-amber-900
      bg-rose-200 text-rose-900
      bg-purple-200 text-purple-900
    ]

    key = (object.id || object.email || object.last_name).to_s
    idx = Zlib.crc32(key) % (palette.length / 2)

    bg = palette[idx * 2]
    fg = palette[idx * 2 + 1]

    "#{bg} #{fg}"
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
      "Lv." + virtue_rank,
      class: "text-sm font-bold bg-sky-100 text-sky-800 px-2 py-1 rounded-full"
    )
  end

  def total_virtue_points_badge
    h.content_tag(:span, "Vp.#{object.total_virtue_points}",
      class: "text-xs font-bold text-gray-700 px-2 py-1 rounded-full"
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
  def status_text
    return if today_status.blank?
    today_status.status_type_i18n
  end

  STATUS_ICONS = {
    peaceful: <<~SVG,
      <svg class="w-5 h-5 inline-block mr-1 align-middle" fill="currentColor" viewBox="0 0 640 640" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><!--!Font Awesome Free v7.1.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2026 Fonticons, Inc.--><path d="M320 576C461.4 576 576 461.4 576 320C576 178.6 461.4 64 320 64C178.6 64 64 178.6 64 320C64 461.4 178.6 576 320 576zM450.7 372.9C462.6 369.2 474.6 379.2 470.3 391C447.9 452.3 389 496.1 320 496.1C251 496.1 192.1 452.2 169.7 390.9C165.4 379.1 177.4 369.1 189.3 372.8C228.5 385 273 391.9 320 391.9C367 391.9 411.5 385 450.7 372.8zM208 272C208 254.3 222.3 240 240 240C257.7 240 272 254.3 272 272C272 289.7 257.7 304 240 304C222.3 304 208 289.7 208 272zM400 240C417.7 240 432 254.3 432 272C432 289.7 417.7 304 400 304C382.3 304 368 289.7 368 272C368 254.3 382.3 240 400 240z"/></svg>
    SVG

    tired: <<~SVG,
      <svg class="w-5 h-5 inline-block mr-1 align-middle" fill="currentColor" viewBox="0 0 640 640" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><!--!Font Awesome Free v7.1.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2026 Fonticons, Inc.--><path d="M320 576C461.4 576 576 461.4 576 320C576 178.6 461.4 64 320 64C178.6 64 64 178.6 64 320C64 461.4 178.6 576 320 576zM410.6 462.1C390.2 434.1 357.2 416 320 416C282.8 416 249.8 434.1 229.4 462.1C221.6 472.8 206.6 475.2 195.9 467.4C185.2 459.6 182.8 444.6 190.6 433.9C219.7 394 266.8 368 320 368C373.2 368 420.3 394 449.4 433.9C457.2 444.6 454.8 459.6 444.1 467.4C433.4 475.2 418.4 472.8 410.6 462.1zM208 272C208 254.3 222.3 240 240 240C257.7 240 272 254.3 272 272C272 289.7 257.7 304 240 304C222.3 304 208 289.7 208 272zM400 240C417.7 240 432 254.3 432 272C432 289.7 417.7 304 400 304C382.3 304 368 289.7 368 272C368 254.3 382.3 240 400 240z"/></svg>
    SVG

    busy: <<~SVG,
      <svg class="w-5 h-5 inline-block mr-1 align-middle" fill="currentColor" viewBox="0 0 640 640" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><!--!Font Awesome Free v7.1.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2026 Fonticons, Inc.--><path d="M320 576C461.4 576 576 461.4 576 320C576 178.6 461.4 64 320 64C178.6 64 64 178.6 64 320C64 461.4 178.6 576 320 576zM228.7 392.7C250.7 370.7 282.6 352 320 352C357.4 352 389.3 370.7 411.3 392.7C422.4 403.8 431.4 416.1 437.7 428.1C443.9 439.8 448 452.5 448 464C448 469.2 445.4 474.2 441.1 477.2C436.8 480.2 431.3 480.9 426.4 479L405.9 471.3C379 461.2 350.4 456 321.6 456L318.4 456C289.6 456 261.1 461.2 234.1 471.3L213.6 479C208.7 480.8 203.2 480.2 198.9 477.2C194.6 474.2 192 469.2 192 464C192 452.4 196.2 439.8 202.3 428.1C208.6 416.1 217.6 403.8 228.7 392.7zM186.6 223.2C191.1 216.4 199.9 214 207.2 217.7L286.8 257.7C292.2 260.4 295.6 265.9 295.6 272C295.6 278.1 292.2 283.6 286.8 286.3L207.2 326.3C199.9 329.9 191.1 327.6 186.6 320.8C182.1 314 183.5 304.9 189.7 299.7L223 272L189.8 244.3C183.6 239.1 182.2 230 186.7 223.2zM450.2 244.3L417 272L450.2 299.7C456.4 304.9 457.8 314 453.3 320.8C448.8 327.6 440 330 432.7 326.3L353.1 286.3C347.7 283.6 344.3 278.1 344.3 272C344.3 265.9 347.7 260.4 353.1 257.7L432.7 217.7C440 214.1 448.8 216.4 453.3 223.2C457.8 230 456.4 239.1 450.2 244.3z"/></svg>
    SVG

    very_busy: <<~SVG,
      <svg class="w-5 h-5 inline-block mr-1 align-middle" fill="currentColor" viewBox="0 0 640 640" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><!--!Font Awesome Free v7.1.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2026 Fonticons, Inc.--><path d="M320 576C461.4 576 576 461.4 576 320C576 178.6 461.4 64 320 64C178.6 64 64 178.6 64 320C64 461.4 178.6 576 320 576zM198.1 217.9L224 243.8L249.9 217.9C257.7 210.1 270.4 210.1 278.2 217.9C286 225.7 286 238.4 278.2 246.2L252.3 272.1L278.2 298C286 305.8 286 318.5 278.2 326.3C270.4 334.1 257.7 334.1 249.9 326.3L224 300.4L198.1 326.3C190.3 334.1 177.6 334.1 169.8 326.3C162 318.5 162 305.8 169.8 298L195.7 272.1L169.8 246.2C162 238.4 162 225.7 169.8 217.9C177.6 210.1 190.3 210.1 198.1 217.9zM390.1 217.9L416 243.8L441.9 217.9C449.7 210.1 462.4 210.1 470.2 217.9C478 225.7 478 238.4 470.2 246.2L444.3 272.1L470.2 298C478 305.8 478 318.5 470.2 326.3C462.4 334.1 449.7 334.1 441.9 326.3L416 300.4L390.1 326.3C382.3 334.1 369.6 334.1 361.8 326.3C354 318.5 354 305.8 361.8 298L387.7 272.1L361.8 246.2C354 238.4 354 225.7 361.8 217.9C369.6 210.1 382.3 210.1 390.1 217.9zM320 368C355.3 368 384 396.7 384 432C384 467.3 355.3 496 320 496C284.7 496 256 467.3 256 432C256 396.7 284.7 368 320 368z"/></svg>
    SVG

    overloaded: <<~SVG,
      <svg class="w-5 h-5 inline-block mr-1 align-middle" fill="currentColor" viewBox="0 0 640 640" <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><!--!Font Awesome Free v7.1.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2026 Fonticons, Inc.--><path d="M320 576C461.4 576 576 461.4 576 320C576 178.6 461.4 64 320 64C178.6 64 64 178.6 64 320C64 461.4 178.6 576 320 576zM464 416C464 441.2 444.6 461.8 420 463.8L420 368.1C444.6 370.1 464 390.8 464 415.9zM340 368L380 368L380 464L340 464L340 368zM260 464L260 368L300 368L300 464L260 464zM220 368.2L220 463.9C195.4 461.9 176 441.2 176 416.1C176 391 195.4 370.3 220 368.3zM208 272C208 254.3 222.3 240 240 240C257.7 240 272 254.3 272 272C272 289.7 257.7 304 240 304C222.3 304 208 289.7 208 272zM400 240C417.7 240 432 254.3 432 272C432 289.7 417.7 304 400 304C382.3 304 368 289.7 368 272C368 254.3 382.3 240 400 240z"/></svg>
    SVG

    day_off: <<~SVG
      <svg class="w-5 h-5 inline-block mr-1 align-middle" fill="currentColor" viewBox="0 0 640 640" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640"><!--!Font Awesome Free v7.1.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2026 Fonticons, Inc.--><path d="M320 576C461.4 576 576 461.4 576 320C576 178.6 461.4 64 320 64C178.6 64 64 178.6 64 320C64 461.4 178.6 576 320 576zM229.4 385.9C249.8 413.9 282.8 432 320 432C357.2 432 390.2 413.9 410.6 385.9C418.4 375.2 433.4 372.8 444.1 380.6C454.8 388.4 457.2 403.4 449.4 414.1C420.3 454 373.2 480 320 480C266.8 480 219.7 454 190.6 414.1C182.8 403.4 185.2 388.4 195.9 380.6C206.6 372.8 221.6 375.2 229.4 385.9zM240 244C224.5 244 212 256.5 212 272L212 280C212 291 203 300 192 300C181 300 172 291 172 280L172 272C172 234.4 202.4 204 240 204C277.6 204 308 234.4 308 272L308 280C308 291 299 300 288 300C277 300 268 291 268 280L268 272C268 256.5 255.5 244 240 244zM372 272L372 280C372 291 363 300 352 300C341 300 332 291 332 280L332 272C332 234.4 362.4 204 400 204C437.6 204 468 234.4 468 272L468 280C468 291 459 300 448 300C437 300 428 291 428 280L428 272C428 256.5 415.5 244 400 244C384.5 244 372 256.5 372 272z"/></svg>
    SVG
  }.freeze

  def status_icon_html
    return "" if today_status.blank?

    icon_svg = STATUS_ICONS[today_status.status_type.to_sym]
    icon_svg || ""  # 念のため
  end

  # HTMLバッジ付きステータス表示（Tailwind CSS版）
  def status_badge_html
    if today_status.blank?
      h.content_tag(:span, "未登録",
        class: "px-3 py-1 text-sm rounded-full bg-gray-200 text-gray-700"
      )
    else
      color_class = STATUS_COLORS[today_status.status_type] || "bg-gray-100 text-gray-800"

      h.content_tag(
        :span,
        h.raw("#{status_icon_html} #{status_text}"), # ← アイコン追加！
        class: "px-3 py-1 text-sm rounded-full #{color_class} inline-flex items-center"
      )
    end
  end

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

  def memo_icon_svg
    <<~SVG
      <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-gray-600" viewBox="0 0 640 640"><!--!Font Awesome Free v7.1.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2026 Fonticons, Inc.--><path d="M64 304C64 358.4 83.3 408.6 115.9 448.9L67.1 538.3C65.1 542 64 546.2 64 550.5C64 564.6 75.4 576 89.5 576C93.5 576 97.3 575.4 101 573.9L217.4 524C248.8 536.9 283.5 544 320 544C461.4 544 576 436.5 576 304C576 171.5 461.4 64 320 64C178.6 64 64 171.5 64 304zM158 471.9C167.3 454.8 165.4 433.8 153.2 418.7C127.1 386.4 112 346.8 112 304C112 200.8 202.2 112 320 112C437.8 112 528 200.8 528 304C528 407.2 437.8 496 320 496C289.8 496 261.3 490.1 235.7 479.6C223.8 474.7 210.4 474.8 198.6 479.9L140 504.9L158 471.9zM208 336C225.7 336 240 321.7 240 304C240 286.3 225.7 272 208 272C190.3 272 176 286.3 176 304C176 321.7 190.3 336 208 336zM352 304C352 286.3 337.7 272 320 272C302.3 272 288 286.3 288 304C288 321.7 302.3 336 320 336C337.7 336 352 321.7 352 304zM432 336C449.7 336 464 321.7 464 304C464 286.3 449.7 272 432 272C414.3 272 400 286.3 400 304C400 321.7 414.3 336 432 336z"/></svg>
    SVG
  end

  # 今日のステータスのメモを取得
  def today_status_memo
    today_status&.memo&.presence || "未設定"
  end

  # メモが存在するかチェック
  def today_status_memo?
    today_status&.memo&.presence.present?
  end

  # メモのHTMLバッジを返す
  def status_memo_html
    return nil unless today_status_memo?

    h.content_tag(:div, class: "mt-2") do
      h.content_tag(:p, class: "text-xs text-gray-700") do
        h.concat(
          h.content_tag(:span, class: "flex items-center gap-1 text-sm font-medium text-gray-600") do
            h.raw(memo_icon_svg) + "メモ"
          end
        )
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
      class: "text-gray-500 text-sm hover:text-gray-900 px-2 py-1 rounded transition inline-flex items-center gap-1" do
      h.raw <<~HTML
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
        </svg>
        <span>編集</span>
      HTML
    end
  end

  def status_reset_button_html
    return unless today_status

      h.button_to h.status_path(today_status),
      method: :delete,
      data: { turbo_method: :delete, turbo_confirm: "本当にリセットしますか?" },
      class: "text-gray-500 text-sm hover:text-gray-900 px-2 py-1 rounded transition inline-flex items-center gap-1" do
      h.raw <<~HTML
        <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
            d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
        </svg>
        <span>削除</span>
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
      class: "text-xs bg-indigo-100 text-indigo-800 px-2 py-1 rounded-full"
  end

  # 進行中のタスクセクション全体
  def in_progress_tasks_section(current_user)
    return nil if in_progress_tasks.empty?

    h.content_tag :div, class: "mt-4 pt-4 border-t border-gray-200" do
      h.concat in_progress_tasks_header
      h.concat in_progress_tasks_list(current_user)
    end
  end

  # タスク一覧リンク(自分のカードの場合のみ表示)
  def tasks_index_link
    return nil unless h.current_user == object

    h.content_tag :div, class: "mt-3" do
      h.link_to "▶︎ タスク一覧を見る", h.tasks_path,
        class: "bg-sky-700 hover:bg-sky-600 text-white font-bold py-2 px-4 rounded text-sm block text-center w-full"
    end
  end

  # =====================================
  # help_magic表示
  # =====================================

  def available_time_with_icon
    return nil unless help_magic&.available_time  # 直接アクセス可能

    h.content_tag :span, class: "flex items-center gap-1" do
      h.concat h.content_tag(:span, "⏰")
      h.concat help_magic.available_time_i18n
    end
  end

  # =====================================
  # シャチークの給湯室
  # =====================================

  # ヘルパーがヘルプ中かどうかの判定
  def helping_now?(matching_helper_ids = nil)
    if matching_helper_ids.present?
      # 事前計算した helper_ids に含まれるかどうか → 超高速
      matching_helper_ids.include?(object.id)
    else
      # 従来の DB クエリ判定（fallback）
      object.helper? && object.received_help_requests.exists?(status: :matched)
    end
  end

  # -------------------------------------
  # virtue_points付与バッジ
  # -------------------------------------

  def total_virtue_points_unread_badge_html(current_user)
    # 本人だけに表示
    return nil unless object.id == current_user&.id

    # 未読なら表示
    return nil unless object.total_virtue_points_notified_at.present? &&
                      object.total_virtue_points_read_at.nil?

    added = object.total_virtue_points_last_added.to_i
    text  = added.positive? ? "🔔 徳ポイント +#{added}" : "🔔 徳ポイント加算あり"

    h.link_to(
      h.read_total_virtue_points_users_path,
      data: { turbo_method: :patch },
      class: "px-3 py-1 text-xs rounded-full bg-yellow-400 text-yellow-900 font-bold shadow animate-pulse inline-block",
      title: "クリックで既読にします"
    ) do
      text
    end
  end

  private

  # -------------------------------------
  # タスク表示 - private
  # -------------------------------------

  # タスクセクションのヘッダー
  def task_icon_svg
    <<~SVG
      <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
        <path stroke-linecap="round" stroke-linejoin="round" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
      </svg>
    SVG
  end

  def in_progress_tasks_header
    h.content_tag :div, class: "flex items-center justify-between mb-2" do
      h.concat(
        h.content_tag(:span, class: "flex items-center gap-1 text-sm font-medium text-gray-600") do
          h.raw(task_icon_svg) + " 本日のタスク"
        end
      )
      h.concat in_progress_tasks_badge
    end
  end

  # タスクリスト
  def in_progress_tasks_list(current_user)
    h.content_tag :ol, class: "list-decimal list-inside space-y-1 text-sm text-gray-700" do
      in_progress_tasks.each do |task|
        h.concat task.decorate.list_item_with_actions(current_user, object)
      end
    end
  end
end
