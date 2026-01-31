class AddKanaToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :last_name_kana, :string
    add_column :users, :first_name_kana, :string
  end
end
