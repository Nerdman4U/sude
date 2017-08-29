require 'test_helper'

class UserHistoryTest < ActiveSupport::TestCase

  def teardown
    DatabaseCleaner.clean
  end

  test 'should associate vote to user history' do
    vote = create(:vote)
    assert_equal vote.user_histories.count, 1
    
    history = create(:user_history, vote: vote)
    assert history.vote
    assert_equal vote.user_histories.count, 2
    
    history = create(:user_history, vote: vote)
    assert history.vote
    assert_equal vote.user_histories.count, 3
  end

  test 'should associate users to user history' do
    vote = create(:vote)

    user = create(:user)
    history = create(:user_history, vote: vote)
    user.user_histories << history
    vote.reload

    assert_equal vote.user_histories.count, 2
    assert_equal user.user_histories.count, 1

    assert vote.user_histories[1].users.count, 1
    assert vote.user_histories[1].users.include?(user)    
  end
  
  test 'should create user history record' do
    vote = create(:vote)
    assert create(:user_history, vote: vote)
  end
  
end
