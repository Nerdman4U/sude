class UserHistory < ApplicationRecord
  has_many :user_user_histories
  has_many :users, through: :user_user_histories
  belongs_to :vote
end
