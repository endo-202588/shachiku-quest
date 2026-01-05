class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, success: '勇者登録が完了しました'
    else
      flash.new[:danger] = '勇者登録に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :department, :email, :password, :password_confirmation, :avatar, :avatar_cache)
  end
end
