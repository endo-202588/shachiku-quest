class UpdateExistingUserLevels < ActiveRecord::Migration[7.2]
  def change
    User.where(level: 0).update_all(level: 1)
  end
end
