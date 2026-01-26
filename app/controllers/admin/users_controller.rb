class Admin::UsersController < Admin::BaseController
  def index
    @users = User.order(:id)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    attrs = user_params.to_h

    if @user.id == current_user.id
      attrs.delete("role")
    end

    if @user.update(attrs)
      redirect_to admin_users_path, notice: "更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(params[:id])
    return redirect_to admin_users_path, alert: "自分自身は削除できません" if user.id == current_user.id

    user.destroy!
    redirect_to admin_users_path, notice: "削除しました"
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :department, :email, :role)
  end
end
