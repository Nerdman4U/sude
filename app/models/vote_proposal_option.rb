class VoteProposalOption < ApplicationRecord
  validates :name, presence: true
  validate :validate_name

  # | is used to join options to a string vote.selected_options
  def validate_name
    if name.match(/\|/)
      errors.add(:name, "cannot have a '|' character")
    end
  end
  
end
