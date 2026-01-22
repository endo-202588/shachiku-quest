class ChangeHelperIdToNullableInHelpRequests < ActiveRecord::Migration[7.2]
  def change
    change_column_null :help_requests, :helper_id, true
  end
end
