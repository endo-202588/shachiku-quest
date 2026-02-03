class MakeKanaNotNullOnUsers < ActiveRecord::Migration[7.2]
  def up
    execute <<~SQL
      UPDATE users
      SET last_name_kana  = COALESCE(last_name_kana, ''),
          first_name_kana = COALESCE(first_name_kana, '')
    SQL

    change_column_null :users, :last_name_kana, false
    change_column_null :users, :first_name_kana, false
  end

  def down
    change_column_null :users, :last_name_kana, true
    change_column_null :users, :first_name_kana, true
  end
end
