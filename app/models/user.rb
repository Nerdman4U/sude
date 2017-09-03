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

  # Status is used when voting should a vote proposal be
  # published. Status "preview" is used when voting unpublished
  # proposal. Status nil is used when voting real published proposal. 
  def has_voted? proposal, status=nil
    votes.any? { |vote| vote.vote_proposal == proposal and vote.status == status }
  end

  # NOTE: Validated user (who has paid through web bank) has status 1.
  def defaults_for_new
    self.status = 0
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


  # NOTE: Below methods are unused. Voting is done with nested_parameters
  #
  # # Vote an unpublished proposal.
  # #
  # # When proposal gets enough (currently 2 or more) Accept- votes it
  # # will be published.
  # #
  # # TODO: check that user has permission for this proposal (!)
  # def preview_vote proposal, value
  #   return unless proposal
  #   return unless proposal.is_a?(VoteProposal)
  #   return unless ["Accept","Decline"].include?(value)
  #   return if has_voted?(proposal, "preview")
    
  #   option = VoteProposalOption.where(name: value).first ||
  #            VoteProposalOption.create(name: value)
  #   this_vote = vote proposal, option, "preview"

  #   proposal.send(:check_publication_status)
  #   this_vote
  # end

  # # This method does the voting
  # #
  # # Params: proposal  VoteProposal object
  # #         values    An array of VoteProposalOption objects or a single
  # #                   record
  # #         status    nil == normal vote
  # #                   "preview" == vote for unpublished previewed vote
  # # Returns: Vote object (valid or not)
  # #
  # # check that user has permission for this proposal (!)
  # def vote proposal, values, status=nil
  #   return unless proposal
  #   return unless proposal.is_a?(VoteProposal)
  #   return if values.blank?

  #   if has_voted? proposal
  #     Rails.logger.error("User (#{id} #{username}) has already voted this proposal (#{proposal.id} #{proposal.topic})")
  #     return
  #   end
    
  #   values = [values] if values.is_a?(VoteProposalOption)
  #   # values = values.filter.map {|v| !v.is_a?(VoteProposal)}
  #   vote = Vote.create({
  #                        user: self,
  #                        vote_proposal: proposal,
  #                        vote_proposal_options: values,
  #                        status: status
  #                      })
  #   vote
  # end


end


