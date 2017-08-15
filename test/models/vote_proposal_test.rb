require 'test_helper'

class VoteProposalTest < ActiveSupport::TestCase

  # Is it possible to return all items in one query?
  #
  # - VoteProposals without groups (global)
  # - VoteProposals in the groups user has access
  # - user Votes in VoteProposals (vote_proposal.vote)
  # - Groups where user has access (vote_proposals.groups)
  #
  test 'should return global proposals or proposals in the groups user is with Arel' do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    # query = VoteProposal.global_arel
    # ActiveRecord::Base.connection.execute(query.to_sql)
  end

  test 'should return vote proposals in the groups user is' do
    vps = VoteProposal.in_permitted_groups(users('one'))
    assert_equal vps.count, 1
    assert vps.first.groups.count > 0
  end

  test 'should return global vote proposals' do
    vps = VoteProposal.global.to_a
    assert_equal vps.count, 1
    assert_equal vps.first.topic, "Ehdotus 3"
  end
  
  test 'should return global proposals or proposals in the groups user is' do
    vps = VoteProposal.global_or_permitted(users('one'))
    assert_equal vps.count, 2
    assert vps[1].groups.count > 0
  end
    
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
