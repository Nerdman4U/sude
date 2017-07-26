require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should create a User' do
    assert users('one').persisted?
  end
  test 'should not create User with duplicate email' do
    assert_raise do
      User.create(email: "test1@test.fi")
    end
  end
  test 'should have default status active' do
    assert_equal users('one').status, "active"
  end
  test 'should return a fixed user with one Vote' do
    assert_equal users('one').votes.count, 1
  end
  test 'should return a fixed user with one VoteProposal' do
    assert_equal users('one').vote_proposals.count, 1
  end
  
end
