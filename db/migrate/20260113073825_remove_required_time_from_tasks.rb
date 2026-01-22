class RemoveRequiredTimeFromTasks < ActiveRecord::Migration[7.2]
  def change
    remove_column :tasks, :required_time, :integer
  end
end
