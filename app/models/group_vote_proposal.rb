class GroupVoteProposal < ApplicationRecord
  belongs_to :group
  belongs_to :vote_proposal
end
