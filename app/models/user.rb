class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
  has_many :votes, :inverse_of => :user
  has_many :user_vote_proposals
  has_many :vote_proposals, through: :user_vote_proposals
  has_many :group_permissions
  has_many :groups, -> {distinct}, through: :group_permissions
  has_many :user_user_histories
  has_many :user_histories, through: :user_user_histories
  
  enum status: [:active, :disabled, :removed]

  # todo: maybe we could have a scope to retrieve all groups with permissions where user belongs
  # scope :groups_with_permissions, -> { joins(:groups,:group_permissions).select("groups.id as group_id,groups.name as groupname,users.id as user_id,users.username,group_permissions.acl") }

  after_initialize :defaults_for_new

  def cached_groups
    Rails.cache.fetch("Cached-groups-for-the-user-#{username}", expires_in: 12.hours) do
      groups
    end
  end

  def vote_in_proposal proposal
    votes.includes(:vote_proposal).select {|vote| vote.vote_proposal == proposal}.first
  end

  def has_voted? proposal
    votes.any? {|vote| vote.vote_proposal == proposal}
  end

  def defaults_for_new
    self.status = 0
  end

  # This method does the voting
  #
  # Params: proposal  VoteProposal object
  #         values    An array of VoteProposalOption objects or a single record
  # Returns: Vote object (valid or not)
  #
  def vote proposal, values
    # check that user has permission for this proposal (!)
    return unless proposal
    return unless proposal.is_a?(VoteProposal)
    return if values.blank?

    if has_voted? proposal
      Rails.logger.error("User (#{id} #{username}) has already voted this proposal (#{proposal.id} #{proposal.topic})")
      return
    end
    
    values = [values] if values.is_a?(VoteProposalOption)
    # values = values.filter.map {|v| !v.is_a?(VoteProposal)}
    vote = Vote.create({
                         user: self,
                         vote_proposal: proposal,
                         vote_proposal_options: values
                       })
    vote
  end

  def permission group
    groups.where(id: group.id).joins(:group_permissions).
      select("groups.id,group_permissions.acl,group_permissions.id as permission_id").first
  end

  def modify_permission group, acl
    if group.blank?
      Rails.logger.error("User.add_permission: Group cannot be blank.")
      return
    end
    unless acl.is_a? String
     Rails.logger.error("User.add_permission: acl must be a string.")
      return
    end
    perm = permission(group)
    acl = yield perm
    GroupPermission.find(perm.permission_id).update_attributes({acl: acl})
  end
  
  # Add a string of access keys to group access control list
  # (group_permissions.acl).
  #
  # Acl is unique list of keys and sorted.
  #
  # For example:
  # acl: "rx"
  # add_permission(group, "w") => acl: "rwx"
  #
  # Parameters:  group  Group object
  #              acl    a string e.g. "r", "rw", etc.
  # Returns: GroupPermission object
  def add_permission group, acl
    modify_permission(group, acl) { |perm|
      [perm.acl.to_s.split(""), acl.split("")].flatten.map(&:strip).
        uniq.sort.join
    }
  end
  def remove_permission group, acl
    modify_permission(group, acl) { |perm|
      (perm.acl.to_s.split("") - acl.split("")).join
    }
  end
  def remove_permissions group
    modify_permission(group, "") { |perm| "" }
  end
  
end


