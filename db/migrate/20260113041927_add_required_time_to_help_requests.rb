class AddRequiredTimeToHelpRequests < ActiveRecord::Migration[7.2]
  def change
    add_column :help_requests, :required_time, :integer, null: false
  end
end
