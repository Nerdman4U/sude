class User < ApplicationRecord
  has_many :votes
  has_many :user_vote_proposals
  has_many :vote_proposals, through: :user_vote_proposals
  enum status: [:active, :disabled, :removed]

  after_initialize :defaults_for_new

  def defaults_for_new
    self.status = 0
  end
end


