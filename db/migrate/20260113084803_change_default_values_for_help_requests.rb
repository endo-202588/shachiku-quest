class ChangeDefaultValuesForHelpRequests < ActiveRecord::Migration[7.2]
  def change
    change_column_default :help_requests, :status, from: nil, to: 0
    change_column_default :help_requests, :required_time, from: nil, to: 0
  end
end
