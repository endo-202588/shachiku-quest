class AddCompletionNotificationToHelpRequests < ActiveRecord::Migration[7.2]
  def change
    add_column :help_requests, :completed_notified_at, :datetime
    add_column :help_requests, :completed_read_at, :datetime
  end
end
