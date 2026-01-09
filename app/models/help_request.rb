class HelpRequest < ApplicationRecord
  belongs_to :task
  belongs_to :helper
end
