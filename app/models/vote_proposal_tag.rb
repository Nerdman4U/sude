class VoteProposalTag < ApplicationRecord
  has_many :vote_proposal_vote_proposal_tag
  has_many :vote_proposals, through: :vote_proposal_vote_proposal_tag
end
