class HelpMagicsController < ApplicationController
  def new
    @help_magic = current_user.help_magics.build
  end

  def create
    @help_magic = current_user.help_magics.build(help_magic_params)
    if @help_magic.save
      redirect_to tasks_path, success: '魔法を登録しました'
    else
      flash.now[:danger] = '魔法を登録できませんでした'
      render :new, status: :unprocessable_entity
    end
  end

  private
    def help_magic_params
      params.require(:help_magic).permit(:available_time, :available_date)
    end
end
