class CreateHelpMagics < ActiveRecord::Migration[7.2]
  def change
    create_table :help_magics do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :available_time, default: 0, null: false
      t.date :available_date, null: false

      t.timestamps
    end

    add_index :help_magics, [ :user_id, :available_date ]
  end
end
