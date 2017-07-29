require 'test_helper'

class UserTest < ActiveSupport::TestCase
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
