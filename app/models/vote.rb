class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :vote_proposal
  has_many :vote_vote_proposal_options
  has_many :vote_proposal_options, through: :vote_vote_proposal_options

  validates :user, :vote_proposal, presence: true
  validate :vote_proposal_options_must_be_found_at_proposal

  before_save :defaults_before_save
  
  accepts_nested_attributes_for :vote_proposal_options

  def defaults_before_save
    self.selected_options = build_selected_options
    update_proposal_counter_cache if self.valid?
  end

  # Add counter only when creating new vote.
  def update_proposal_counter_cache
    return unless new_record?

    vote_proposal_options.each do |option|
      record = vote_proposal.find_counter_cache_record(option)
      if user.confirmed?
        count = record.confirmed_vote_count
        count = count.blank? ? 1 : count + 1
        record.update_column(:confirmed_vote_count, count)
      else
        count = record.anonymous_vote_count
        count = count.blank? ? 1 : count + 1
        record.update_column(:anonymous_vote_count, count)
      end
    end
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
