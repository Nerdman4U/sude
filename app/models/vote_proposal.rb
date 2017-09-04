class VoteProposal < ApplicationRecord
  extend FriendlyId

  friendly_id :topic, use: [:slugged, :history]
  
  has_many :user_vote_proposals
  has_many :users, -> {distinct}, through: :user_vote_proposals
  has_many :votes
  has_many :preview_votes
  has_many :group_vote_proposals
  has_many :groups, -> {distinct}, through: :group_vote_proposals
  has_many :vote_proposal_vote_proposal_tags
  has_many :vote_proposal_tags, -> {distinct}, through: :vote_proposal_vote_proposal_tags
  has_many :vote_proposal_vote_proposal_options
  has_many :vote_proposal_options, -> {distinct}, through: :vote_proposal_vote_proposal_options
  belongs_to :circle, inverse_of: :vote_proposals

  validates :topic, uniqueness: true

  accepts_nested_attributes_for :vote_proposal_options, allow_destroy: true

  after_initialize :defaults_for_new
  after_save :check_publication_status

  scope :published, -> {
    where("published_at < ?", Time.now)
  }

  scope :unpublished, -> {
    where("published_at > ? OR published_at IS NULL", Time.now)
  }

  scope :all_with_groups, -> {
    left_joins(:groups).group("vote_proposals.id")
  }

  scope :global, -> {
    all_with_groups.having("count(groups.id) = 0 AND published_at < ?", Time.now)
  }

  scope :in_permitted_groups, -> (user) {
    left_joins(:groups => [:group_permissions, :users]).where("group_permissions.user_id = ? AND published_at < ?", user.id, Time.now);
  }

  scope :in_permitted_group, -> (user, group) {
    # left_joins(:groups => [:group_permissions, :users]).where("group_permissions.user_id = ? and group_permissions.group_id = ? AND published_at < ?", user.id, group.id, Time.now);
    joins(:groups => [:group_permissions]).where("group_permissions.user_id = ? and group_permissions.group_id = ? AND published_at < ?", user.id, group.id, Time.now);
  }
  
  scope :global_or_permitted, -> (user) {
    global.includes(:votes) + in_permitted_groups(user).includes(:votes)
  }
  
  # NOTE: this is just for testing purposes
  scope :permitted_with_sql, -> (user) {
    find_by_sql('SELECT vote_proposals.id, groups.id FROM "vote_proposals" LEFT JOIN "group_vote_proposals" ON "group_vote_proposals"."vote_proposal_id" = "vote_proposals"."id" LEFT JOIN "groups" ON groups.id = group_vote_proposals.group_id LEFT JOIN "group_permissions" ON "group_permissions.group_id" = "groups.id" WHERE group_permissions.user_id = 980190962') 
  }
  # NOTE: this is a test
  scope :global_arel, -> {
    proposals = Arel::Table.new(:vote_proposals)
    group_vote_proposals = Arel::Table.new(:group_vote_proposals)
    proposals.join(group_vote_proposals).on(group_vote_proposals[:vote_proposals_id].eq(proposals[:id]))
    # proposals.join(group_vote_proposals, Arel::Nodes::OuterJoin).on(group_vote_proposals[:vote_proposal_id].eq(group_vote_proposals[:group_id]))
  }
   
  # Find the join table for given vote proposal option.
  #
  # Params: option VoteProposalOption
  #
  def find_counter_cache_record option
    vote_proposal_vote_proposal_options.where(vote_proposal_option_id: option.id).first
  end
  # def find_counter_cache_record2 option
  #   vote_proposal_vote_proposal_options.select {|join_table|
  #     join_table.vote_proposal_option_id == option.id
  #   }.first
  # end
  
  def defaults_for_new
    max_options = 1 if max_options.blank?
    min_options = 1 if min_options.blank?
  end

  def published?
    !!(published_at and published_at < Time.now + 3.seconds)
  end

  # VoteProposal is published after it has two accept votes.
  def check_publication_status
    if votes.where(status: "preview", selected_options: "Accept").size > 1
      update_column(:published_at, Time.now)
    end
  end
  
end
