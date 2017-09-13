# coding: utf-8
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable  
  has_many :votes, -> { includes [:vote_proposal, :vote_proposal_options] }, :inverse_of => :user
  has_many :user_vote_proposals
  has_many :vote_proposals, through: :user_vote_proposals
  has_many :group_permissions
  has_many :groups, -> {distinct}, through: :group_permissions
  has_many :user_user_histories
  has_many :user_histories, through: :user_user_histories
  has_many :mandate_users, foreign_key: :user_id, source: :mandate_from
  has_many :mandate_users2, class_name: "MandateUser", foreign_key: :mandate_from_id, source: :user
  has_many :mandates_from, class_name: "User", through: :mandate_users, source: :mandate_from
  has_many :mandates_to, class_name: "User", through: :mandate_users2, foreign_key: :mandate_from_id, source: :user
  
  has_many :mandate_votes, foreign_key: :mandate_from
  has_many :votes_from_mandate, through: :mandate_votes, source: :vote

  enum status: [:active, :disabled, :removed]

  # todo: maybe we could have a scope to retrieve all groups with permissions where user belongs
  # scope :groups_with_permissions, -> { joins(:groups,:group_permissions).select("groups.id as group_id,groups.name as groupname,users.id as user_id,users.username,group_permissions.acl") }

  after_initialize :defaults_for_new
  before_create :defaults_before_create

  # Give mandate to user
  #
  # Reload target user (user with mandate) mandates_from association
  # after add to clear cached mandates_from association proxy.
  #
  # without reload:
  # => user2.give_mandate(user)
  # => user.mandates_from
  # >> []
  def give_mandate user
    mandates_to << user
    user.mandates_from.reload
  end

  def remove_mandate user
    mandates_to.delete user
  end
  
  def cached_groups
    Rails.cache.fetch("Cached-groups-for-the-user-#{username}", expires_in: 12.hours) do
      groups
    end
  end
  
  def vote_in_proposal proposal
    votes.select {|vote|
      vote.vote_proposal == proposal and vote.status == nil
    }.first
  end

  def confirm
    # For each vote we must find join table and change the vote value
    # from anonymous to confirmed
    votes.each do |vote|
      proposal = vote.vote_proposal
      vote.vote_proposal_options.each do |opt|
        join_table = proposal.find_counter_cache_record(opt)
        a_count = join_table.anonymous_vote_count || 0
        c_count = join_table.confirmed_vote_count || 0
        join_table.update_attributes({
                                       anonymous_vote_count: a_count - 1,
                                       confirmed_vote_count: c_count + 1
                                     })
          
      end
    end
    self.confirmed = true
  end

  # Status is used when voting should a vote proposal be
  # published. Status "preview" is used when voting unpublished
  # proposal. Status nil is used when voting real published proposal. 
  def has_voted? proposal, status=nil
    votes.reload.any? { |vote|
      vote.vote_proposal == proposal and
      vote.status == status and
      vote.vote_proposal_options.present?
    }
  end

  # NOTE: Validated user (who has paid through web bank) has status 1.
  def defaults_for_new
    self.status = 0
  end
  def defaults_before_create
    self.username = email.split("@")[0] if username.blank?
    self.fullname = username if fullname.blank?
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


  # Vote an unpublished proposal.
  #
  # When proposal gets enough (currently 2 or more) Accept- votes it
  # will be published.
  #
  # params:   proposal   VoteProposal object
  #           value      VoteProposalOption object
  #
  # TODO: check that user has permission for this proposal (!)
  def preview_vote proposal, value
    return unless proposal
    return unless proposal.is_a?(VoteProposal)
    return if value.blank?
    return unless ["Accept","Decline"].include?(value.name)
    return if has_voted?(proposal, "preview")
    
    this_vote = vote proposal, value, status: "preview"
    proposal.publish if proposal.publish?
    this_vote
  end

  # Voting.
  #
  # Create vote if user has not voted proposal. Update if user has
  # voted. Do this for every user who has given mandate to this user
  # except:
  # - Do nothing If user who has given mandate has already voted
  # this proposal
  #
  # Params: proposal  VoteProposal object
  #         values    An array of VoteProposalOption objects or a single
  #                   record
  #         options:  status     nil       normal vote
  #                              preview   vote for unpublished proposal
  #
  # Returns: List of votes
  #
  # NOTE: Use "preview_vote" method when votin unpublished vote.
  # NOTE: check that user has permission for this proposal
  def vote proposal, values=[], options={}
    return unless proposal
    return unless proposal.is_a?(VoteProposal)
    # return if values.blank?
    values = [values] if values.is_a?(VoteProposalOption)
    status = options[:status]
    action = options[:action] || :add

    voting_users = [self]
    voting_users += mandates_from.to_a
    voting_users.map do |user|
      vote = user.vote_in_proposal(proposal)        
      if not vote
        user.create_vote proposal, values, status, self
      else
        if user != self and user.has_voted?(proposal)
          # if we are voting for mandate giver but user has already
          # voted by itself do nothing 
        else
          if action == :add
            add_vote_option vote, values, self
          else
            remove_vote_option vote, values, self
          end
        end
      end
    end
  end

  def remove_vote_option vote, values, voted_by
    to_be_removed = vote.vote_proposal_options.select {|o| values.include?(o) }

    vote.voted_by = voted_by
    vote.vote_proposal_options.delete to_be_removed
    vote.save
  end
  
  def add_vote_option vote, values, voted_by
    opt_ids = vote.vote_proposal_options.map(&:id) + values.map(&:id)
    max = vote.vote_proposal.max_options || 1
    return if opt_ids.count > max

    vote.voted_by = voted_by
    vote.vote_proposal_options << values
    vote.save
  end
  
  # Create new vote.
  #
  # Create one vote for self and one vote for each mandate this user
  # has.
  def create_vote proposal, values, status, voted_by
    max = proposal.max_options || 1
    return if values.count > max
    
    params = {
      user: self,
      voted_by: voted_by,
      vote_proposal: proposal,
      vote_proposal_options: values,
      status: status
    }
    votes.create(params)
  end
end


