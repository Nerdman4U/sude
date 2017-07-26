require 'test_helper'

class VoteProposalTest < ActiveSupport::TestCase
  test 'should create persisted vote_proposal object' do
    assert vote_proposals('one').persisted?
  end
  test 'should have an array of users' do
    assert vote_proposals('one').users.count > 0
  end
  test 'should have an array of votes' do
    assert vote_proposals('one').votes.count > 0
  end
  test 'should have an array of groups' do
    assert vote_proposals('one').groups.count > 0
  end
  test 'should have an array of vote_proposal_tags' do
    assert vote_proposals('one').vote_proposal_tags.count > 0
  end
  test 'should have an array of vote_proposal_options' do
    assert vote_proposals('one').vote_proposal_options.count > 0
  end
end
