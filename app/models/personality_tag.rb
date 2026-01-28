class PersonalityTag < ApplicationRecord
  has_many :user_personality_tags, dependent: :destroy
  has_many :users, through: :user_personality_tags

  validates :name, presence: true, uniqueness: true
end
