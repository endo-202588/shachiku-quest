class AddVirtuePointsToHelpRequests < ActiveRecord::Migration[7.2]
  def change
    add_column :help_requests, :virtue_points, :integer, null: false, default: 10
  end
end
