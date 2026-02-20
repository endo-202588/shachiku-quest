class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
  end

  def create
    @user = login(params[:email], params[:password])

    if @user
      if @user.today_status.present?
        # ステータスがあればユーザー一覧へ
        redirect_to users_path
      else
        # ステータスがなければステータス入力画面へ
        redirect_to new_status_path
      end
    else
      flash.now[:danger] = "魔法の鍵が合いません...メールアドレスかパスワードが間違っています"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, success: "冒険を終えて帰還しました。またのお越しをお待ちしております!"
  end
end
