class AddUniqueIndexToStatusesUserIdStatusDate < ActiveRecord::Migration[7.2]
  def change
    remove_index :statuses, name: "index_statuses_on_user_id_and_status_date"
    add_index :statuses, [:user_id, :status_date],
      unique: true,
      name: "index_statuses_on_user_id_and_status_date"
  end
end
