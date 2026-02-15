class AddMatchedNotifiedAtToHelpRequests < ActiveRecord::Migration[7.2]
  def change
    add_column :help_requests, :matched_notified_at, :datetime
  end
end
