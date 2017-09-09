class MandateVote < ApplicationRecord
  belongs_to :mandate_from, class_name: "User"
  belongs_to :vote
end

