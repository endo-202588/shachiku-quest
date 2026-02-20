class AddUniqueIndexToUserPersonalityTags < ActiveRecord::Migration[7.2]
  def change
    add_index :user_personality_tags, [ :user_id, :personality_tag_id ], unique: true
  end
end
