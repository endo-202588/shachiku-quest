class Settings::PasswordsController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user

    unless correct_current_password?(@user, params[:current_password])
      @user.errors.add(:base, "現在のパスワードが正しくありません")
      return render :edit, status: :unprocessable_entity
    end

    # Sorcery: password / password_confirmation を更新すると暗号化される想定
    @user.password = password_params[:password]
    @user.password_confirmation = password_params[:password_confirmation]

    if @user.save
      redirect_to settings_profile_path, notice: "パスワードを変更しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # Sorceryのプロジェクト差を吸収（前と同じ考え方）
  def correct_current_password?(user, raw_password)
    return false if raw_password.blank?

    if user.class.respond_to?(:authenticate)
      return user.class.authenticate(user.email, raw_password).present?
    end

    if user.respond_to?(:valid_password?)
      return user.valid_password?(raw_password)
    end

    false
  end
end
