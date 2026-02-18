class Conversation < ApplicationRecord
  belongs_to :help_request
  has_many :messages, dependent: :destroy
end
