class CreateStatusHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :status_histories do |t|
      t.references :status, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :old_status_type
      t.integer :new_status_type
      t.datetime :changed_at

      t.timestamps
    end
  end
end
