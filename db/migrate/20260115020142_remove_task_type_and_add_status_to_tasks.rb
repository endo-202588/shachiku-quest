class RemoveTaskTypeAndAddStatusToTasks < ActiveRecord::Migration[7.2]
  def change
    remove_column :tasks, :task_type, :integer
    add_column :tasks, :status, :integer, default: 0, null: false
  end
end
