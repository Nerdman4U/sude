class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :vote_proposal
  has_many :vote_vote_proposal_options
  has_many :vote_proposal_options, through: :vote_vote_proposal_options
end
