class VoteProposalVoteProposalOption < ApplicationRecord
  belongs_to :vote_proposal
  belongs_to :vote_proposal_option
end
