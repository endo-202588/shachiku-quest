class UserPersonalityTag < ApplicationRecord
  belongs_to :user
  belongs_to :personality_tag

  validates :personality_tag_id, uniqueness: { scope: :user_id }
end
