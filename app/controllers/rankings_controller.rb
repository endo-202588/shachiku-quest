class RankingsController < ApplicationController
  before_action :require_login

  def show
    @users = User.order(total_virtue_points: :desc, id: :asc)
  end
end
