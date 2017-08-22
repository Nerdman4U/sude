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


  scope :global_arel, -> {
    proposals = Arel::Table.new(:vote_proposals)
    group_vote_proposals = Arel::Table.new(:group_vote_proposals)
    proposals.join(group_vote_proposals).on(group_vote_proposals[:vote_proposals_id].eq(proposals[:id]))
    # proposals.join(group_vote_proposals, Arel::Nodes::OuterJoin).on(group_vote_proposals[:vote_proposal_id].eq(group_vote_proposals[:group_id]))
  }
  
  scope :all_with_groups, -> {
    left_joins(:groups).group("vote_proposals.id")
  }

  scope :global, -> {
    all_with_groups.having("count(groups.id) = 0")
  }

  scope :in_permitted_groups, -> (user) {
    left_joins(:groups => [:group_permissions, :users]).where("group_permissions.user_id = ?", user.id);
  }

  scope :in_permitted_group, -> (user, group) {
    left_joins(:groups => [:group_permissions, :users]).where("group_permissions.user_id = ? and group_permissions.group_id = ?", user.id, group.id);
  }
  
  scope :global_or_permitted, -> (user) {
    global.includes(:votes) + in_permitted_groups(user).includes(:votes)
  }
  
  # NOTE: this is just for testing purposes
  scope :permitted_with_sql, -> (user) {
    find_by_sql('SELECT vote_proposals.id, groups.id FROM "vote_proposals" LEFT JOIN "group_vote_proposals" ON "group_vote_proposals"."vote_proposal_id" = "vote_proposals"."id" LEFT JOIN "groups" ON groups.id = group_vote_proposals.group_id LEFT JOIN "group_permissions" ON "group_permissions.group_id" = "groups.id" WHERE group_permissions.user_id = 980190962') 
  }
  

  # Find join table for vote proposal option.
  #
  # It is expected that this method is called after querying records
  # with includes. Select wont trigger sql queries as where would.
  #
  # params: option VoteProposalOption
  #
  # TODO: rename as "find_join_table_record" (?)
  def find_counter_cache_record option
    # vote_proposal_vote_proposal_options.select(vote_proposal_option_id: option.id).first
    vote_proposal_vote_proposal_options.select {|join_table|
      join_table.vote_proposal_option_id == option.id
    }.first
  end

  
end
