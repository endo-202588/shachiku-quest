class AddIndexToStatusesUserIdStatusDate < ActiveRecord::Migration[7.2]
  def change
    return if index_exists?(:statuses, [:user_id, :status_date], name: "index_statuses_on_user_id_and_status_date")

    add_index :statuses, [:user_id, :status_date], name: "index_statuses_on_user_id_and_status_date"
  end
end
