class AddTaskTypeToTasks < ActiveRecord::Migration[7.2]
  def change
    add_column :tasks, :task_type, :integer, default: 0, null: false
    remove_column :tasks, :status
  end
end
