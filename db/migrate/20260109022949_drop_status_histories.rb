class DropStatusHistories < ActiveRecord::Migration[7.2]
  def change
    drop_table :status_histories, if_exists: true
  end
end
