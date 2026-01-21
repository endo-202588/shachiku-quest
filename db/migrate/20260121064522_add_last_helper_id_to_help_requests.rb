class AddLastHelperIdToHelpRequests < ActiveRecord::Migration[7.2]
  def change
    add_column :help_requests, :last_helper_id, :bigint
    add_index  :help_requests, :last_helper_id
  end
end
