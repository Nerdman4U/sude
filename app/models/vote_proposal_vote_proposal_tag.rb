class VoteProposalVoteProposalTag < ApplicationRecord
  belongs_to :vote_proposal
  belongs_to :vote_proposal_tag
end
