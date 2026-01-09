class CreateHelpRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :help_requests do |t|
      t.references :task, null: false, foreign_key: true
      t.references :helper, null: false, foreign_key: { to_table: :users }
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :help_requests, [:task_id, :helper_id], unique: true
    add_index :help_requests, :status
  end
end
