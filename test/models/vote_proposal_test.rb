require 'test_helper'

class VoteProposalTest < ActiveSupport::TestCase

  test 'should find vote proposal with old and new slugged name' do
    old_slug = vote_proposals('one').slug
    vote_proposals('one').topic = "foobar"
    vote_proposals('one').save
    assert_equal vote_proposals('one').friendly_id, "ehdotus-1"

    vote_proposals('one').slug = nil
    vote_proposals('one').save
    assert_equal vote_proposals('one').friendly_id, "foobar"

    assert VoteProposal.friendly.find("foobar")
    assert VoteProposal.friendly.find(old_slug)       
  end
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
