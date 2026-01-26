class StatusDecorator < Draper::Decorator
  delegate_all

  def display_type
    object.status_type_i18n
  end

end
