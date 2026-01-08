class AddDiscardedAtToStatuses < ActiveRecord::Migration[7.2]
  def change
    add_column :statuses, :discarded_at, :datetime
    add_index :statuses, :discarded_at
  end
end
