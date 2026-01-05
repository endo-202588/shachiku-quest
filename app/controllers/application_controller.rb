class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :require_login

  private

  def not_authenticated
    redirect_to login_path, danger: 'ログインしてください'
  end
end
