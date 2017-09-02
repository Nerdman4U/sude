class Vote < ApplicationRecord
  belongs_to :user, :inverse_of => :votes
  belongs_to :vote_proposal
  has_many :vote_vote_proposal_options
  has_many :vote_proposal_options, through: :vote_vote_proposal_options
  has_many :user_histories

  validates :user, :vote_proposal, presence: true
  validate :vote_proposal_options_must_be_found_at_proposal
  validate :user_can_have_only_one_vote_per_proposal

  before_save :defaults_before_save
  
  accepts_nested_attributes_for :vote_proposal_options, allow_destroy: true

  scope :with_options, -> () { joins(:vote_proposal_options) }
  
  # NOTE: This is too heavy validation.
  #
  # User cannot have more than one vote per vote_proposal.
  #
  def user_can_have_only_one_vote_per_proposal
    if Vote.any? { |vote|
         vote.user_id == user_id && vote.vote_proposal_id == vote_proposal_id && vote.id != id
       }
      errors.add(:base,
                 "There can be only one vote in proposal for user")
    end
  end
  
  # Modify parameters for update attributes method.
  #
  # Add vote options from vote to params if they are not included
  # already and vote proposal has an option (min_votes, max_votes) to
  # allow multiple vote options.
  #
  # Note: Vote proposals min_votes option cannot be used currently
  # because user selects options one by one. The first select is always
  # invalid if min_option is greater than 1.
  #
  # Later, this could be done so that in show view vote is saved only
  # after user loads different action. In show update_attributes are
  # building a <tt>new record</tt> and thus validation can occur later.
  def modify_params! params
    max = vote_proposal.max_options
    if params["vote_proposal_option_ids"]
      opt_ids = vote_proposal_options.map(&:id)
      return if max <= opt_ids.count
      ids = params["vote_proposal_option_ids"]
      ids << opt_ids
      params["vote_proposal_option_ids"] = ids.flatten.uniq
    elsif params["vote_proposal_options_attributes"]
      opt_ids = vote_proposal_options.map {|o| {id: o.id}}
      return if max <= opt_ids.count
      ids = params["vote_proposal_options_attributes"]
      ids << opt_ids
      params["vote_proposal_options_attributes"] = ids.flatten.uniq
    end
  end

  def defaults_before_save
    self.selected_options = build_selected_options
    
    if self.valid?
      update_proposal_counter_cache 
      add_user_history
    end
    
  end

  def add_user_history
    self.user_histories << UserHistory.new(vote: self, users: [self.user])
  end

  # Update counter cache column in vote proposal. Anonymous users have
  # different cache. 
  # 
  # Add counter only when creating new vote.
  #
  # TODO: Why we are adding counter cache for every OPTION?
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

  # Build a string for a column +selected_options+.
  #
  # This is a backup/debug solution at this time.
  def build_selected_options
    vote_proposal_options.map(&:name).sort.join("|")    
  end

  def vote_proposal_options_must_be_found_at_proposal
    unless verify_vote_proposal_options
      errors.add(:vote_proposal_options, "is not found from the vote proposal")
    end
  end
  
  # Returns true if selected vote options are found from proposal.
  #
  def verify_vote_proposal_options
    return true unless vote_proposal_options
    correct_options = vote_proposal.vote_proposal_options.map(&:name)
    vote_proposal_options.all? do |option|
      correct_options.index(option.name)
    end
  end
end
