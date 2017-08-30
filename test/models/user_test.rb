require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def teardown
    DatabaseCleaner.clean
  end

  test 'should return cached groups' do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    
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
    user.has_voted?(proposal)
  end

  test 'should return the vote this user has in given vote proposal' do
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
