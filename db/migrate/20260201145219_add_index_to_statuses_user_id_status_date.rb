class AddIndexToStatusesUserIdStatusDate < ActiveRecord::Migration[7.2]
  def change
    add_index :statuses, [:user_id, :status_date]
  end
end
