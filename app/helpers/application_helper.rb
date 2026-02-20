module ApplicationHelper
  def top_page?
    controller_path == "static_pages" && action_name == "top"
  end

  def hide_footer_nav?
    (controller_path == "users" && action_name == "index") ||
    (controller_path == "dashboard" && action_name == "show")
  end
end
