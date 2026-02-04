class StatusDecorator < Draper::Decorator
  delegate_all

  def display_type
    object.status_type_i18n
  end

  def status_type_with_explanation
    short = object.status_type_i18n
    desc  = I18n.t("status_type_explanations.#{object.status_type}", default: nil)

    desc.present? ? "#{short}（#{desc}）" : short
  end
end
