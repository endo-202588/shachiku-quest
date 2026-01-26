class Admin::BaseController < ApplicationController
  before_action :require_login
  before_action :require_admin!

  private

  def require_admin!
    return if current_user&.admin?
    redirect_to users_path, alert: "権限がありません"
  end
end
