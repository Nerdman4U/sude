require 'test_helper'

class UserHistoryTest < ActiveSupport::TestCase

  def teardown
    DatabaseCleaner.clean
  end

  test 'should update selected_options after adding a vote' do
    vote = create(:vote)
    vote.vote_proposal_options << vote.vote_proposal.vote_proposal_options.first
    history = vote.user_histories.first
    assert_equal vote.user_histories.count, 1
    assert_equal history.selected_options, vote.selected_options
    assert_equal history.selected_action, "add"
  end

  test 'should associate vote to user history' do
    user = create(:user)
    proposal = create(:vote_proposal, :with_options)
    vote = create(:vote, user: user, vote_proposal: proposal, vote_proposal_options: [proposal.vote_proposal_options.first])
    assert_equal vote.user_histories.count, 1
    
    history = create(:user_history, vote: vote)
    assert history.vote
    assert_equal vote.user_histories.count, 2
    
    history = create(:user_history, vote: vote)
    assert history.vote
    assert_equal vote.user_histories.count, 3
  end

  test 'should associate users to user history' do
    user = create(:user)
    proposal = create(:vote_proposal, :with_options)
    vote = create(:vote, user: user, vote_proposal: proposal, vote_proposal_options: [proposal.vote_proposal_options.first])
    assert_equal vote.user_histories.count, 1
    
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
