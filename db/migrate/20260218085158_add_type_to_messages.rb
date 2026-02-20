class AddTypeToMessages < ActiveRecord::Migration[7.2]
  def change
    add_column :messages, :message_type, :integer, null: false, default: 0
    add_column :messages, :event_type, :integer

    change_column_null :messages, :sender_id, true

    add_index :messages, :message_type
    add_index :messages, :event_type
  end
end
