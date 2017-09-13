require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    # After changing mySQL from SQLLite DatabaseCleaner wont work, table
    # truncate raises. Using only transaction does not work either too
    # good. Deleting users seems to work good enough. Need to find a
    # solution. 
    # DatabaseCleaner.strategy = :transaction
    # DatabaseCleaner.clean
    User.delete_all
  end

  # Find join table record
  def rec proposal, opt
    proposal.send(:find_counter_cache_record, opt)
  end
  
  def rec_count proposal, opt, rec_type="a"
    rec_type = rec_type == "a" ? "anonymous" : "confirmed"
    rec(proposal, opt).send("#{rec_type}_vote_count") || 0
  end

  test 'should change vote counts after confirmation' do    
    user1 = create(:user)
    proposal = create(:vote_proposal, :with_options)
    opt1 = proposal.vote_proposal_options.first
    user1.vote(proposal, opt1)
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    query_count = count_queries do
      user1.confirm
    end
    assert_equal query_count, 5
    assert_equal rec_count(proposal, opt1), 0
    assert_equal rec_count(proposal, opt1, "c"), 1    
  end

  test 'should have correct vote counts before and after confirmation' do
    user1 = create(:user)
    proposal = create(:vote_proposal, :with_options)
    opt1 = proposal.vote_proposal_options.first

    # Vote unconfirmed
    user1.vote(proposal, opt1)
    assert_equal rec_count(proposal, opt1), 1
    assert_equal rec_count(proposal, opt1, "c"), 0

    user1.confirm

    # Vote confirmed
    user1.vote(proposal, opt1, action: :delete)
    assert_equal rec_count(proposal, opt1), 0
    assert_equal rec_count(proposal, opt1, "c"), 0
  end

  test 'should have default values' do
    user1 = User.create(email: "foo@bar.com", password: "foobar")
    assert_equal user1.username, "foo"
    assert_equal user1.fullname, "foo"
  end

  test 'should add correct user to history after voting with mandate' do
    user1 = create(:user)
    proposal = create(:vote_proposal, :with_options)
    opt1 = proposal.vote_proposal_options.first
    opt2 = proposal.vote_proposal_options.second
    opt3 = proposal.vote_proposal_options.third
    user2 = create(:user)
    user2.give_mandate(user1)
    assert user1.mandates_from.include?(user2)

    # create vote
    user1.vote(proposal, opt1)
    assert_equal user1.votes.first.user_histories.first.users.first, user1
    assert_equal user2.votes.first.user_histories.first.users.first, user1

    # update vote
    user1.vote proposal, opt1, action: :delete
    user2.vote proposal, opt1, action: :delete
    user1.vote(proposal, opt2)
    assert_equal user1.votes.first.user_histories.first.users.first, user1
    assert_equal user2.votes.first.user_histories.first.users.first, user1
    
  end

  test 'should vote and count votes correctly with mandate' do
    user1 = create(:user)
    proposal = create(:vote_proposal, :with_options)
    assert_not user1.has_voted?(proposal)
    opt1 = proposal.vote_proposal_options.first
    opt2 = proposal.vote_proposal_options.second
    opt3 = proposal.vote_proposal_options.third
    user2 = create(:user)
    user2.give_mandate(user1)
    assert user1.mandates_from.include?(user2)

    # Vote with mandate
    # (vote for opt1)
    user1.vote(proposal, opt1)
    assert user1.has_voted?(proposal)
    assert user2.has_voted?(proposal)
    assert_equal Vote.count, 2
    assert Vote.all {|v| v.voted_by == user1 }
    assert_equal user2.votes.size, 1
    assert_equal rec_count(proposal,opt1), 2
    assert_equal rec_count(proposal,opt2), 0
    assert_equal rec_count(proposal,opt3), 0
    
    # Override previous vote by updating a vote by user2
    # (vote for opt2)
    user2.vote proposal, opt1, action: :delete
    user2.vote proposal, opt2
    assert_equal user2.vote_in_proposal(proposal).vote_proposal_options.size, 1
    assert user2.vote_in_proposal(proposal).vote_proposal_options.include?(opt2)
    assert_equal Vote.count, 2
    assert_equal Vote.last.voted_by, user2
    assert_equal rec_count(proposal,opt1), 1
    assert_equal rec_count(proposal,opt2), 1
    assert_equal rec_count(proposal,opt3), 0

    # Do not override previous vote from mandate owner
    # (vote for opt3)
    user1.vote proposal, opt1, action: :delete
    user1.vote(proposal, opt3)
    assert_equal Vote.count, 2
    assert_equal rec_count(proposal,opt1), 0
    assert_equal rec_count(proposal,opt2), 1
    assert_equal rec_count(proposal,opt3), 1

    # Remove vote options
    user2.vote proposal, [opt2], {action: :remove}
    assert_equal rec_count(proposal,opt1), 0
    assert_equal rec_count(proposal,opt2), 0
    assert_equal rec_count(proposal,opt3), 1
    user1.vote proposal, [opt3], {action: :remove}
    assert_equal rec_count(proposal,opt1), 0
    assert_equal rec_count(proposal,opt2), 0
    assert_equal rec_count(proposal,opt3), 0

    # Remove invalid option
    user1.vote proposal, [opt1], {action: :remove}
    assert_equal rec_count(proposal,opt1), 0
    assert_equal rec_count(proposal,opt2), 0
    assert_equal rec_count(proposal,opt3), 0

    # Should not change vote if mandate giver has already voted
    user2.vote(proposal, opt1)
    assert_equal rec_count(proposal,opt1), 1
    assert_equal rec_count(proposal,opt2), 0
    assert_equal rec_count(proposal,opt3), 0
    user1.vote(proposal, opt2)
    assert_equal rec_count(proposal,opt1), 1
    assert_equal rec_count(proposal,opt2), 1
    assert_equal rec_count(proposal,opt3), 0

    # Should allow mandate if user has vote without options
    user2.vote(proposal, opt1, action: :delete)
    assert_equal rec_count(proposal,opt1), 0
    assert_equal rec_count(proposal,opt2), 1
    assert_equal rec_count(proposal,opt3), 0
    assert user2.vote_in_proposal(proposal)
    assert_not user2.has_voted?(proposal)
    user1.vote(proposal, opt2, action: :delete)
    user1.vote(proposal, opt3)
    assert_equal rec_count(proposal,opt1), 0
    assert_equal rec_count(proposal,opt2), 0
    assert_equal rec_count(proposal,opt3), 2        
  end

  test 'should give a mandate to another user' do
    user1 = create(:user)
    user2 = create(:user)
    user2.give_mandate(user1)
    
    assert_equal user1.mandate_users.size, 1
    assert_equal user2.mandate_users2.size, 1
    assert user1.mandates_from.include?(user2)
    assert user2.mandates_to.include?(user1)    
  end
  
  test 'should return users who have given mandate' do
    user1 = create(:user)
    user2 = create(:user)

    # user2 gives a mandate to user1
    user1.mandates_from << user2

    # user1 has a through table record...
    assert_equal user1.mandate_users.size, 1
    # user2 has same record but opposite way.
    assert_equal user2.mandate_users2.size, 1
    
    assert user1.mandates_from.include?(user2)
    assert user2.mandates_to.include?(user1)
    
    user3 = create(:user)
    user1.mandates_from << user3
    assert_equal user1.mandate_users.size, 2
    assert_equal user2.mandate_users2.size, 1
    assert_equal user2.mandate_users.size, 0
    assert_equal user3.mandate_users2.size, 1
    assert_equal user3.mandate_users.size, 0
    
    assert user3.mandates_to.include?(user1)
    assert user1.mandates_from.include?(user2)
    assert user1.mandates_from.include?(user3)    
  end

  test 'should return cached groups' do
    #ActiveRecord::Base.logger = Logger.new(STDOUT)
    
    user = create(:user)

    # Retrieving groups should generate one query.
    user.groups << create(:group)
    q_count = count_queries do
      groups = user.cached_groups
      assert_equal groups.size, 1
    end
    assert_equal q_count, 1

    # Retrieving groups again should not generate sql query. 
    q_count = count_queries do
      user.cached_groups
    end
    assert_equal q_count, 0    
    
    # Rails detects that association proxy has been changed and
    # retrieves groups from database.
    user.groups << create(:group)    
    q_count = count_queries do
      groups = user.cached_groups
      assert_equal groups.size, 2
    end
    assert_equal q_count, 1
  end

  test 'should remove jointable record when user is removed' do
    user = create(:user_with_group)
    count = GroupPermission.where(user_id: user.id).count
    assert count > 0
    group2 = create(:group)
    assert_difference "GroupPermission.count" do
      user.groups << group2
    end
    #assert_difference "GroupPermission.count" do
    #  user.destroy
    #end
  end

  test 'should return true if the user has voted this proposal' do
    user = create(:user_with_votes)
    proposal = user.votes.first.vote_proposal
    vote = user.votes.first
    vote.vote_proposal_options << proposal.vote_proposal_options.first
    assert user.has_voted?(proposal)

    # should not return true if user has voted preview
    user.votes.each do |vote|
      vote.update_attributes({status: "preview"})
    end
    assert_not user.has_voted?(proposal)    
    assert user.has_voted?(proposal, "preview")
  end

  test 'should return the votes in proposal' do
    user = create(:user_with_votes)
    proposal = user.votes.first.vote_proposal
    vote = user.vote_in_proposal(proposal)
    assert vote
    assert vote.is_a? Vote
    assert_equal vote.vote_proposal, proposal
  end

  test 'should add and remove permissions' do
    user = create(:user_with_group)
    group = user.groups.first

    perm = GroupPermission.where(user_id: user.id, group_id: group.id).first
    assert perm.present?
    assert_equal perm.acl, ""

    user.add_permission(group, 'rw')
    perm.reload
    assert_equal perm.acl, "rw"

    user.add_permission(group, 'x')
    perm.reload
    assert_equal perm.acl, "rwx"

    user.remove_permission(group, 'w')
    perm.reload
    assert_equal perm.acl, "rx"

    user.remove_permissions(group)
    perm.reload
    assert_equal perm.acl, ""
    
    user.add_permission(group, 'xrw')
    perm.reload
    assert_equal perm.acl, "rwx"    
  end

  test 'should allow user to preview vote unpublished vote proposal' do
    user = create(:user)
    assert_difference 'Vote.count' do
      proposal = create(:vote_proposal_with_options, published_at: nil)
      option = create(:vote_proposal_option, name: "Accept")
      user.preview_vote(proposal, option)
    end
    assert_equal Vote.last.status, "preview"

    # Should not allow preview vote with wrong name
    assert_no_difference 'Vote.count' do
      proposal = create(:vote_proposal_with_options, published_at: nil)
      option = create(:vote_proposal_option, name: "Yes")
      user.preview_vote(proposal, option)
    end
  end
  
  test 'should allow user to vote a vote proposal' do
    user = create(:user)
    assert_difference 'Vote.count' do
      proposal = create(:vote_proposal_with_options)
      option = proposal.vote_proposal_options.first
      user.vote(proposal, option)
    end
  end
  
  test 'should create a User' do
    assert create(:user).persisted?
  end
  
  test 'should not create User with duplicate email' do
    user1 = create(:user)
    email = user1.email
    user2 = build(:user, {email: email})
    assert_not user2.valid?
  end
  
  test 'should have default status active' do
    assert_equal build(:user).status, "active"
  end
end
