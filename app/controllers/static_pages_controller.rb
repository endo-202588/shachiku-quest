class StaticPagesController < ApplicationController
  skip_before_action :require_login
  skip_before_action :check_today_status

  def top
    # トップページを表示
  end

  def terms
  end

  def privacy
  end
end
