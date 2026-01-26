class AddEmailChangeFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :unconfirmed_email, :string
    add_column :users, :email_change_token, :string
    add_column :users, :email_change_token_expires_at, :datetime

    add_index :users, :unconfirmed_email
    add_index :users, :email_change_token, unique: true
  end
end
