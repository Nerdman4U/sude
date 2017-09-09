class Vote < ApplicationRecord
  belongs_to :user, inverse_of: :votes
  belongs_to :vote_proposal, inverse_of: :votes
  has_many :vote_vote_proposal_options
  
  # NOTE: after_remove is deprecated because options are no longer removed, new vote without
  #       options is created instead
  has_many :vote_proposal_options, through: :vote_vote_proposal_options,
           after_add: [:add_counter, :add_history],
           after_remove: [:sub_counter, Proc.new {|v,o| v.send(:add_history,o,:remove)}],
           before_add: [:add_selected_option],
           before_remove: [:remove_selected_option]
  has_many :user_histories  
  has_many :mandate_votes, foreign_key: :vote_id, source: :mandate_from
  has_many :mandates_from, class_name: "User", through: :mandate_votes, source: :mandate_from
  belongs_to :voted_by, class_name: "User", foreign_key: :voted_by_id

  validates :user, :vote_proposal, presence: true
  validate :vote_proposal_options_must_be_found_at_proposal

  before_save :defaults_before_save
  
  accepts_nested_attributes_for :vote_proposal_options, allow_destroy: true

  scope :with_options, -> () { joins(:vote_proposal_options) }
  
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
    max = vote_proposal.max_options || 1
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

  private

  # TODO: Voting cache should also remove vote counts if changed option
  def defaults_before_save
    self.selected_options = build_selected_options

    max = vote_proposal.max_options || 1
    if vote_proposal_options.size > max
      self.errors.add("Too many options added")
    end
  end

  # NOTE: DEPRECATED
  # # NOTE: This is too heavy validation.
  # #
  # # User cannot have more than one vote per vote_proposal.
  # #
  # def user_can_have_only_one_vote_per_proposal
  #   if Vote.any? { |vote|
  #        vote.user_id == user_id && vote.vote_proposal_id == vote_proposal_id && vote.id != id
  #      }
  #     errors.add(:base,
  #                "There can be only one vote in proposal for user")
  #   end
  # end
  
  def add_history(option, action = :add)
    users = [self.voted_by]
    users << self.user if self.voted_by != self.user    
    history = UserHistory.new(vote: self, users: users)
    history.selected_options = option.name
    history.selected_action = action
    self.user_histories << history
  end
  
  # Update counter cache columns in the join table.
  #
  # NOTE: This should be in VoteProposal
  def update_proposal_counter_cache option, value
    return unless valid?
    return unless status.blank?
    return unless vote_proposal.published?

    record = vote_proposal.find_counter_cache_record(option)
    if user.confirmed?
      count = record.confirmed_vote_count || 0
      count = count + value
      record.update_column(:confirmed_vote_count, count)
    else
      count = record.anonymous_vote_count || 0
      count = count + value
      record.update_column(:anonymous_vote_count, count)
    end    
  end

  # Update selected options string. 
  def add_selected_option(option)
    if new_record?
      self.selected_options = build_selected_options
    else
      update_column(:selected_options, build_selected_options(vote_proposal_options + [option]))
    end
  end

  # Update selected options string. 
  def remove_selected_option(option)
    if new_record?
      self.selected_options = build_selected_options
    else
      update_column(:selected_options, build_selected_options(vote_proposal_options - [option]))
    end
  end
  
  def add_counter(option)
    return unless status.blank?
    return unless vote_proposal.published?
    update_proposal_counter_cache option, 1
  end
  
  def sub_counter(option)
    return unless status.blank?
    return unless vote_proposal.published?
    update_proposal_counter_cache option, -1
  end

  def counter_values
    vote_proposal_options.map do |option|
      record = vote_proposal.find_counter_cache_record(option)
      {id: id, a: record.anonymous_vote_count, c: record.confirmed_vote_count}
    end
  end
  
  # Build a string for a column +selected_options+.
  #
  # This is a backup/debug solution at this time.
  def build_selected_options options=nil
    options ||= vote_proposal_options
    options.map(&:name).sort.join("|")    
  end

  def vote_proposal_options_must_be_found_at_proposal
    unless verify_vote_proposal_options
      errors.add(:vote_proposal_options, "is not found from the vote proposal")
    end
  end
  
  # Returns true if selected vote options are found from proposal.
  #
  # Note: Vote which is "preview" must allow accept and decline options
  # even they are not found from proposal. Preview votes are used for
  # acceptance of unpublished vote proposal.
  def verify_vote_proposal_options
    return true unless vote_proposal_options
    if status == "preview"
      correct_options = vote_proposal.vote_proposal_options.map(&:name)
      correct_options << "Accept"
      correct_options << "Decline"
    else
      correct_options = vote_proposal.vote_proposal_options.map(&:name)
    end

    vote_proposal_options.all? do |option|
      correct_options.index(option.name)
    end    
  end
end
