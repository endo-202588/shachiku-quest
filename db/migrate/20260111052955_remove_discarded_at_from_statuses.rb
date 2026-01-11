class RemoveDiscardedAtFromStatuses < ActiveRecord::Migration[7.2]
  def change
    remove_index :statuses, :discarded_at
    remove_column :statuses, :discarded_at, :datetime
  end
end
