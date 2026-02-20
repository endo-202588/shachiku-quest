class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [ :edit, :update, :destroy, :edit_password, :update_password, :edit_email, :update_email ]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result
              .order(:id)
              .includes(avatar_attachment: :blob)
              .page(params[:page]).per(12)
  end

  def edit
  end

  def update
    attrs = user_params.to_h

    if @user == current_user
      attrs.delete("role")
    end

    if @user.update(attrs)
      redirect_to admin_users_path, success: "更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # --- パスワード変更（管理者が他人のPWを変更） ---
  def edit_password
  end

  def update_password
    # Sorcery想定: password / password_confirmation が使える
    if @user.update(password_params)
      AdminUserChangeMailer.with(user: @user, admin: current_user)
                         .password_changed
                         .deliver_later
      redirect_to edit_admin_user_path(@user), notice: "パスワードを更新しました"
    else
      render :edit_password, status: :unprocessable_entity
    end
  end

  # --- メール変更（管理者が他人のメールを変更） ---
  def edit_email
  end

  def update_email
    old_email = @user.email
    new_email = email_params[:email]

    attrs = email_params.to_h

    if @user.update(attrs.merge(
      unconfirmed_email: nil,
      email_change_token: nil,
      email_change_token_expires_at: nil
    ))
      AdminUserChangeMailer.with(
        user: @user,
        admin: current_user,
        old_email: old_email,
        new_email: new_email
      ).email_changed.deliver_later
      redirect_to edit_admin_user_path(@user), notice: "メールアドレスを更新しました"
    else
      render :edit_email, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(params[:id])
    return redirect_to admin_users_path, danger: "自分自身は削除できません" if user.id == current_user.id

    user.destroy!
    redirect_to admin_users_path, success: "削除しました"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :department, :email, :role, :total_virtue_points)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def email_params
    params.require(:user).permit(:email)
  end
end
