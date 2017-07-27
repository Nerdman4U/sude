class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :vote_proposal
  has_many :vote_vote_proposal_options
  has_many :vote_proposal_options, through: :vote_vote_proposal_options

  validates :user, :vote_proposal, presence: true
  validate :vote_proposal_options_must_be_found_at_proposal

  before_save :defaults_before_save

  def defaults_before_save
    self.selected_options = build_selected_options
  end
  
  def build_selected_options
    vote_proposal_options.map(&:name).sort.join("|")    
  end

  def vote_proposal_options_must_be_found_at_proposal
    unless verify_vote_proposal_options
      errors.add(:vote_proposal_options, "is not found from the vote proposal")
    end
  end
  
  # Selected options must be found from proposal.
  # Return boolean
  def verify_vote_proposal_options
    return true unless vote_proposal_options
    correct_options = vote_proposal.vote_proposal_options.map(&:name)
    vote_proposal_options.all? do |option|
      correct_options.index(option.name)
    end
  end
end
