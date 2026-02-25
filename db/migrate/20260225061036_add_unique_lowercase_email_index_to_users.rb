class AddUniqueLowercaseEmailIndexToUsers < ActiveRecord::Migration[7.2]
  def change
    if index_exists?(:users, :email)
      remove_index :users, :email
    end

    add_index :users,
              "LOWER(email)",
              unique: true,
              name: "index_users_on_lower_email"
  end
end
