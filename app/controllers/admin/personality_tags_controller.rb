class Admin::PersonalityTagsController < Admin::BaseController
  before_action :require_admin!

  def index
    @tags = PersonalityTag.order(:name)
  end

  def destroy
    tag = PersonalityTag.find(params[:id])
    tag.destroy!
    redirect_to admin_personality_tags_path, notice: "タグを削除しました"
  end
end
