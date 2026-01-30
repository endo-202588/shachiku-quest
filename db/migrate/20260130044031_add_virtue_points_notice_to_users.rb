class AddVirtuePointsNoticeToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :virtue_points_notified_at, :datetime
    add_column :users, :virtue_points_read_at, :datetime
    add_column :users, :virtue_points_last_added, :integer
  end
end
