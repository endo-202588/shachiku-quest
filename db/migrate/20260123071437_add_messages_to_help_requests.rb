class AddMessagesToHelpRequests < ActiveRecord::Migration[7.2]
  def change
    add_column :help_requests, :request_message, :text
    add_column :help_requests, :helper_message, :text
  end
end
