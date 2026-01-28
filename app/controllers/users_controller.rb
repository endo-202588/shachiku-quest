class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def index
    @users = User.order(:id)
             .includes(avatar_attachment: :blob) # avatar使うなら
             .page(params[:page]).per(12)
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
      flash.now[:danger] = '勇者登録に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :department, :email, :password, :password_confirmation, :avatar)
  end
end
