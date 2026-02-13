class GuidesController < ApplicationController
  skip_before_action :require_login, raise: false
  def show
  end
end
