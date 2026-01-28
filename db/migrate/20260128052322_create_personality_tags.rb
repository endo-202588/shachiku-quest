class CreatePersonalityTags < ActiveRecord::Migration[7.2]
  def change
    create_table :personality_tags do |t|
      t.string :name

      t.timestamps
    end
  end
end
