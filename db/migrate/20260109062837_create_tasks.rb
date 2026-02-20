class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.integer :status, default: 0, null: false
      t.integer :required_time, default: 0, null: false

      t.timestamps
    end

    add_index :tasks, [ :user_id, :status ]
  end
end
