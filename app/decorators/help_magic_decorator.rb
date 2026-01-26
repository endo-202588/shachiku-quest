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

end
