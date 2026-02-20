class RenameHelpRequestMessagesToHelpRequestChats < ActiveRecord::Migration[7.2]
  def change
    rename_table :help_request_messages, :help_request_chats
  end
end
