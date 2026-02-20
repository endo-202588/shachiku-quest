class CreateHelpRequestMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :help_request_messages do |t|
      t.references :help_request, null: false, foreign_key: true

      t.references :sender, null: true, foreign_key: { to_table: :users }
      t.references :recipient, null: false, foreign_key: { to_table: :users }

      t.integer :message_type, null: false
      t.text :body, null: false
      t.datetime :read_at

      t.timestamps
    end

    add_index :help_request_messages, [ :recipient_id, :read_at ]
    add_index :help_request_messages, [ :help_request_id, :created_at ]
  end
end
