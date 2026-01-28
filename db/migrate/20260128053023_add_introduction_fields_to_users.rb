class AddIntroductionFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :nickname, :string
    add_column :users, :hobbies, :string
    add_column :users, :introduction, :text
  end
end
