class IntroductionsController < ApplicationController
  before_action :require_login
  before_action :set_user
  before_action :ensure_self!,  only: [ :edit, :update ]
  before_action :require_kana!, only: [ :edit, :update ]

  def show
    @user = User.find(params[:id]).decorate
  end

  def edit
  end

  def update
    new_tag_name = params.dig(:user, :new_personality_tag_name).to_s.strip

    begin
      if new_tag_name.present?
        tag = PersonalityTag.find_or_create_by(name: new_tag_name)

        unless tag.persisted?
          flash.now[:danger] = "性格タグを追加できませんでした：#{tag.errors.full_messages.join('、')}"
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
      redirect_to introduction_path(@user), success: "自己紹介を更新しました"
    else
      flash.now[:danger] = "入力内容を確認してください"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_self!
    unless @user == current_user
      redirect_to introduction_path(@user), alert: "他のユーザーの紹介文は編集できません"
    end
  end

  def require_kana!
    if @user.last_name_kana.blank? || @user.first_name_kana.blank?
      redirect_to edit_settings_profile_path, alert: "自己紹介を編集する前に、氏名（かな）を登録してください"
    end
  end

  def introduction_params
    params.require(:user).permit(:nickname, :hobbies, :introduction, personality_tag_ids: [])
  end
end
