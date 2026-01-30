class RenameVirtuePointsColumnsInUsers < ActiveRecord::Migration[7.2]
  def change
    rename_column :users, :virtue_points_notified_at, :total_virtue_points_notified_at
    rename_column :users, :virtue_points_read_at, :total_virtue_points_read_at
    rename_column :users, :virtue_points_last_added, :total_virtue_points_last_added
  end
end
