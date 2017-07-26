class VoteVoteProposalOption < ApplicationRecord
  belongs_to :vote
  belongs_to :vote_proposal_option
end
