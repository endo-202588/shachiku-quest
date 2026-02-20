class Admin::PersonalityTagsController < Admin::BaseController
  before_action :set_personality_tag, only: %i[edit update destroy]

  def index
    @personality_tags = PersonalityTag.order(:name)
  end

  def new
    @personality_tag = PersonalityTag.new
  end

  def create
    @personality_tag = PersonalityTag.new(personality_tag_params)
    if @personality_tag.save
      redirect_to admin_personality_tags_path, success: "タグの登録が完了しました"
    else
      flash.now[:danger] = "タグの登録に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @personality_tag.update(personality_tag_params)
      redirect_to admin_personality_tags_path, success: "タグを更新しました"
    else
      flash.now[:danger] = "タグの更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @personality_tag.destroy
      redirect_to admin_personality_tags_path, success: "タグを削除しました"
    else
      redirect_to admin_personality_tags_path, danger: "タグの削除に失敗しました"
    end
  end

  private

  def set_personality_tag
    @personality_tag = PersonalityTag.find(params[:id])
  end

  def personality_tag_params
    params.require(:personality_tag).permit(:name)
  end
end
