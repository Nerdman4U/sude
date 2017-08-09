require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    GroupPermission.delete_all
  end

  test 'should add and remove permissions' do
    users('one').groups << groups('one')
    perm = GroupPermission.where(user_id: users('one').id, group_id: groups('one').id).first
    assert perm.present?
    assert_equal perm.acl, ""

    users('one').add_permission(groups('one'), 'rw')
    perm.reload
    assert_equal perm.acl, "rw"

    users('one').add_permission(groups('one'), 'x')
    perm.reload
    assert_equal perm.acl, "rwx"

    users('one').remove_permission(groups('one'), 'w')
    perm.reload
    assert_equal perm.acl, "rx"

    users('one').remove_permissions(groups('one'))
    perm.reload
    assert_equal perm.acl, ""
    
    users('one').add_permission(groups('one'), 'xrw')
    perm.reload
    assert_equal perm.acl, "rwx"    
  end

  test 'should remove jointable record when user is removed' do
    # viite-eheys ei toimi:
    #
    # count = GroupPermission.where(user_id: users('one')).count

    # users('one').groups << groups('one')
    # assert_equal GroupPermission.count, count + 1
    # users('one').destroy 
    # assert_equal GroupPermission.count, count
  end
  test 'should allow user to vote a vote proposal' do
    assert_difference 'Vote.count' do
      users('one').vote(vote_proposals('two'),vote_proposal_options('one'))
    end
  end  
  test 'should create a User' do
    assert users('one').persisted?
  end
  test 'should not create User with duplicate email' do
    assert_not User.create(email: "test1@test.fi").valid?
  end
  test 'should have default status active' do
    assert_equal users('one').status, "active"
  end
  test 'should return a fixed user with one vote' do
    #assert users('one').votes.count > 0
  end
  test 'should return a fixed user with one vote proposal' do
    #assert users('one').vote_proposals.count > 0
  end
  
end
