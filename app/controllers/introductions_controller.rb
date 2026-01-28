class IntroductionsController < ApplicationController
  before_action :require_login
  before_action :set_user
  before_action :ensure_self!, only: [:edit, :update]

  def show
    @user = User.find(params[:id]).decorate
  end

  def edit
    # 自分のみ編集可
  end

  def update
    new_tag_name = params.dig(:user, :new_personality_tag_name).to_s.strip

    begin
      if new_tag_name.present?
        tag = PersonalityTag.find_or_create_by(name: new_tag_name)

        unless tag.persisted?
          flash.now[:alert] = "性格タグを追加できませんでした：#{tag.errors.full_messages.join('、')}"
          return render :edit, status: :unprocessable_entity
        end

        ids = Array(params.dig(:user, :personality_tag_ids)).reject(&:blank?).map(&:to_i)
        ids << tag.id
        params[:user][:personality_tag_ids] = ids.uniq
      end
    rescue ActiveRecord::RecordNotUnique
      tag = PersonalityTag.find_by!(name: new_tag_name)
      ids = Array(params.dig(:user, :personality_tag_ids)).reject(&:blank?).map(&:to_i)
      ids << tag.id
      params[:user][:personality_tag_ids] = ids.uniq
    end

    if @user.update(introduction_params)
      redirect_to introduction_path(@user), notice: "自己紹介を更新しました"
    else
      flash.now[:alert] = "入力内容を確認してください"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  # 編集・更新は自分だけ
  def ensure_self!
    unless @user == current_user
      redirect_to introduction_path(@user), alert: "他のユーザーの紹介文は編集できません"
    end
  end

  def introduction_params
    params.require(:user).permit(:nickname, :hobbies, :introduction, personality_tag_ids: [])
  end
end
