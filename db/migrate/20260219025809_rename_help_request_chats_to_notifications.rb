class RenameHelpRequestChatsToNotifications < ActiveRecord::Migration[7.2]
  def up
    rename_table :help_request_chats, :notifications

    rename_indexes(
      table: :notifications,
      from_prefix: "index_help_request_chats",
      to_prefix:   "index_notifications"
    )
  end

  def down
    rename_indexes(
      table: :notifications,
      from_prefix: "index_notifications",
      to_prefix:   "index_help_request_chats"
    )

    rename_table :notifications, :help_request_chats
  end

  private

  def rename_indexes(table:, from_prefix:, to_prefix:)
    connection.indexes(table).each do |idx|
      next unless idx.name.start_with?(from_prefix)

      new_name = idx.name.sub(from_prefix, to_prefix)
      rename_index table, idx.name, new_name
    end
  end
end
