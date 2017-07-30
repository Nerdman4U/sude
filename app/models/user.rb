class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
  has_many :votes
  has_many :user_vote_proposals
  has_many :vote_proposals, through: :user_vote_proposals
  has_many :group_permissions
  has_many :groups, -> {distinct}, through: :group_permissions
  enum status: [:active, :disabled, :removed]

  # todo: maybe we could have a scope to retrieve all groups with permissions where user belongs
  # scope :groups_with_permissions, -> { joins(:groups,:group_permissions).select("groups.id as group_id,groups.name as groupname,users.id as user_id,users.username,group_permissions.acl") }

  after_initialize :defaults_for_new

  def defaults_for_new
    self.status = 0
  end

  # This method does the voting
  #
  # Params: proposal  VoteProposal object
  #         values    An array of VoteProposalOption objects
  # Returns: Vote object (valid or not)
  #
  def vote proposal, values
    return unless proposal
    return unless proposal.is_a?(VoteProposal)
    return if values.blank?
    values = [values] if values.is_a?(VoteProposalOption)
    # values = values.filter.map {|v| !v.is_a?(VoteProposal)}
    Vote.create({
                  user: self,
                  vote_proposal: proposal,
                  vote_proposal_options: values
                })
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


