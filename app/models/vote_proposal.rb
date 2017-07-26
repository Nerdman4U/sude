class VoteProposal < ApplicationRecord
  has_many :user_vote_proposals
  has_many :users, through: :user_vote_proposals
  has_many :votes
  has_many :group_vote_proposals
  has_many :groups, through: :group_vote_proposals
  has_many :vote_proposal_vote_proposal_tags
  has_many :vote_proposal_tags, through: :vote_proposal_vote_proposal_tags
  has_many :vote_proposal_vote_proposal_options
  has_many :vote_proposal_options, through: :vote_proposal_vote_proposal_options
end
