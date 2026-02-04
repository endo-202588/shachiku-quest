class AddMatchedOnToHelpRequests < ActiveRecord::Migration[7.2]
  def change
    add_column :help_requests, :matched_on, :date
  end
end
