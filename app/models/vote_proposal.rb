class VoteProposal < ApplicationRecord
  extend FriendlyId

  friendly_id :topic, use: [:slugged, :history]
  
  has_many :user_vote_proposals
  has_many :users, -> {distinct}, through: :user_vote_proposals
  has_many :votes
  has_many :group_vote_proposals
  has_many :groups, -> {distinct}, through: :group_vote_proposals
  has_many :vote_proposal_vote_proposal_tags
  has_many :vote_proposal_tags, -> {distinct}, through: :vote_proposal_vote_proposal_tags
  has_many :vote_proposal_vote_proposal_options
  has_many :vote_proposal_options, -> {distinct}, through: :vote_proposal_vote_proposal_options

  
  # # TODO: what if topic has numbers
  # def to_param
  #   slug
  # end

  # def slug
  #   [id, topic.parameterize].join("-")
  # end
  
  # params: option VoteProposalOption
  def find_counter_cache_record option
    vote_proposal_vote_proposal_options.where(vote_proposal_option_id: option.id).first
  end

  
end
