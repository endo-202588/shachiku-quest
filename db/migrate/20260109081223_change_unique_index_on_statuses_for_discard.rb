class ChangeUniqueIndexOnStatusesForDiscard < ActiveRecord::Migration[7.2]
  def change
    remove_index :statuses, column: [:user_id, :status_date]

    add_index :statuses, [:user_id, :status_date],
              unique: true,
              where: "discarded_at IS NULL",
              name: "index_statuses_on_user_id_and_status_date_kept"
  end
end
