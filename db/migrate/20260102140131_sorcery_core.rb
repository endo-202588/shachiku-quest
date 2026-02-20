class SorceryCore < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :first_name,       null: false
      t.string :last_name,        null: false
      t.string :department
      t.string :email,            null: false, index: { unique: true }
      t.string :crypted_password
      t.string :salt
      t.string :avatar
      t.integer :level,           default: 0, null: false
      t.integer :total_virtue_points, default: 0, null: false

      t.timestamps null: false
    end
  end
end
