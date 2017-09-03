class VoteProposalOption < ApplicationRecord
  has_many :vote_vote_proposal_options
  has_many :vote_proposal_vote_proposal_options
  has_many :votes, through: :vote_vote_proposal_options
  has_many :vote_proposals, through: :vote_proposal_vote_proposal_options
  
  validates :name, presence: true, uniqueness: true
  validate :validate_name

  # | is used to join options to a string vote.selected_options
  def validate_name
    if name.match(/\|/)
      errors.add(:name, "cannot have a '|' character")
    end
  end

  # Load or create default options for previewed proposal voting
  def self.preview_options
    options = VoteProposalOption.where(name: ["Accept", "Decline"]).to_a
    return options if options.size > 1

    if !options.map(&:name).include?("Decline")
      options << VoteProposalOption.create(name: "Decline")
    end
    
    if !options.map(&:name).include?("Accept")
      options << VoteProposalOption.create(name: "Accept")
    end
    options
  end
  
end
