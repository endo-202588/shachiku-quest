class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def index
    @users = User.includes(:statuses, :in_progress_tasks, :help_request_tasks).all.decorate
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.role = :general
    if @user.save
      redirect_to users_path, success: '勇者登録が完了しました'
    else
      flash.new[:danger] = '勇者登録に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :department, :email, :password, :password_confirmation, :avatar)
  end
end
