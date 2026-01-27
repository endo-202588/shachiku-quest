class Settings::ProfilesController < ApplicationController
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(profile_params)
      redirect_to settings_profile_path, notice: "プロフィールを更新しました"
    else
      flash.now[:alert] = "入力内容を確認してください"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:first_name, :last_name, :department, :avatar)
  end
end
