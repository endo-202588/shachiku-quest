class CreateUserPersonalityTags < ActiveRecord::Migration[7.2]
  def change
    create_table :user_personality_tags do |t|
      t.references :user, null: false, foreign_key: true
      t.references :personality_tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
