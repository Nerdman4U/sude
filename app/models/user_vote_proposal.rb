class UserVoteProposal < ApplicationRecord
  belongs_to :user
  belongs_to :vote_proposal
end
