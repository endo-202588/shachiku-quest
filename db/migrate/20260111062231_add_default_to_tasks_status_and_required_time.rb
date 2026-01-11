class AddDefaultToTasksStatusAndRequiredTime < ActiveRecord::Migration[7.2]
  def change
    change_column_default :tasks, :status, from: nil, to: 0
    change_column_default :tasks, :required_time, from: nil, to: 0
  end
end
