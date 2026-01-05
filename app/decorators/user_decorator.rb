class UserDecorator < Draper::Decorator
  delegate_all

  def full_name
    "#{object.last_name} #{object.first_name}"
  end

  def display_department
    object.department.presence || "未設定"
  end
end
