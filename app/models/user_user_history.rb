class UserUserHistory < ApplicationRecord
  belongs_to :user
  belongs_to :user_history
end
