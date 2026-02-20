class CreateStatuses < ActiveRecord::Migration[7.2]
  def change
    create_table :statuses do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status_type, null: false, default: 0
      t.date :status_date, null: false
      t.text :memo

      t.timestamps
    end

    # 同じユーザーが同じ日付に複数のステータスを登録できないようにする
    add_index :statuses, [ :user_id, :status_date ], unique: true
  end
end
