class MakeKanaNotNullOnUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_null :users, :last_name_kana, false
    change_column_null :users, :first_name_kana, false
  end
end
