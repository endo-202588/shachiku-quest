class HelpMagicsController < ApplicationController
  before_action :require_login
  before_action :set_help_magic, only: %i[edit update destroy]

  def edit
  end

  def update
    if @help_magic.update(help_magic_params)
      redirect_to dashboard_path, notice: "魔法を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @help_magic = current_user.help_magic || current_user.build_help_magic
  end

  def create
    @help_magic = current_user.help_magic || current_user.build_help_magic
    @help_magic.assign_attributes(help_magic_params.merge(available_date: Date.current))

    if @help_magic.save
      redirect_to help_requests_tasks_path, notice: '魔法を登録しました'
    else
      flash.now[:danger] = '魔法を登録できませんでした'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    help_magic = current_user.help_magic

    if help_magic&.destroy
      redirect_to help_requests_tasks_path, notice: '魔法を削除（待機解除）しました'
    else
      redirect_to help_requests_tasks_path, alert: '魔法を削除できませんでした'
    end
  end

  private

    def set_help_magic
      @help_magic = current_user.help_magic
      redirect_to dashboard_path, alert: "魔法が見つかりません" unless @help_magic
    end

    def help_magic_params
      params.require(:help_magic).permit(:available_time)
    end
end
