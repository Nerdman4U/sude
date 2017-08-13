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

  
  # SELECT vote_proposals.id, groups.id FROM "vote_proposals" LEFT JOIN "group_vote_proposals" ON "group_vote_proposals"."vote_proposal_id" = "vote_proposals"."id" LEFT JOIN "groups" ON groups.id = group_vote_proposals.group_id group by vote_proposals.id having count(groups.id) = 0;
  scope :all_with_groups, -> {
    left_joins(:groups).group("vote_proposals.id")
  }
  scope :global, -> {
    all_with_groups.having("count(groups.id) = 0").order(:confirmed_vote_count)
  }
  # Note: This seems to be correct
  scope :in_permitted_groups, -> (user) {
    left_joins(:groups => [:group_permissions, :users]).where("group_permissions.user_id = ?", user.id);
  }
  # TODO: this is not working
  scope :global_or_permitted, -> (user) {
    global.in_permitted_groups(user).unscope(:having)
  }
  scope :permitted_with_sql, -> (user) {
    find_by_sql('SELECT vote_proposals.id, groups.id FROM "vote_proposals" LEFT JOIN "group_vote_proposals" ON "group_vote_proposals"."vote_proposal_id" = "vote_proposals"."id" LEFT JOIN "groups" ON groups.id = group_vote_proposals.group_id LEFT JOIN "group_permissions" ON "group_permissions.group_id" = "groups.id" WHERE group_permissions.user_id = 980190962') 
  }
  
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
