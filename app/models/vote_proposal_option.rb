class VoteProposalOption < ApplicationRecord
  has_many :vote_vote_proposal_options
  has_many :vote_proposal_vote_proposal_options
  has_many :votes, through: :vote_vote_proposal_options
  has_many :vote_proposals, through: :vote_proposal_vote_proposal_options
  
  validates :name, presence: true
  validate :validate_name

  # | is used to join options to a string vote.selected_options
  def validate_name
    if name.match(/\|/)
      errors.add(:name, "cannot have a '|' character")
    end
  end
  
end
