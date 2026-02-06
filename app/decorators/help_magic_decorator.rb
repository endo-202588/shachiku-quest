class HelpMagicDecorator < Draper::Decorator
  delegate_all

  def available_time_text
    object.available_time_i18n
  end

  def required_time_with_icon
    return nil if object.available_time.blank?

    h.content_tag :span, class: 'flex items-center gap-1' do
      h.concat h.content_tag(:span, '⏰')
      h.concat available_time_text
    end
  end

  def header_help_magic_label
    return nil if object.available_time.blank?

    # enumのキーをラベル化
    label = case object.available_time.to_sym
            when :half_hour then "ベハーフ"
            when :one_hour then "ベホワン"
            when :one_and_half_hours then "ベホワンハフ"
            when :two_hours then "ベホツ"
            when :long_time then "ベホロング"
            end

    "魔法：#{label}"
  end

  def header_help_magic_label_with_time
    return nil if object.available_time.blank?

    # enumのキーをラベル化
    label = case object.available_time.to_sym
            when :half_hour then "ベハーフ（30分）"
            when :one_hour then "ベホワン（1時間）"
            when :one_and_half_hours then "ベホワンハフ（1時間30分）"
            when :two_hours then "ベホツ（2時間）"
            when :long_time then "ベホロング（2時間以上）"
            end

    "魔法：#{label}"
  end

  def help_magic_text
    return nil if object.available_time.blank?

    # enumのキーをラベル化
    label = object.available_time_i18n

    "現在登録中の魔法：#{label}"
  end
end
