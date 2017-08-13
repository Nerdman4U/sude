require 'test_helper'

class VoteProposalTest < ActiveSupport::TestCase

  test 'should return proposals in the groups current user has' do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    # proposals = VoteProposal.with_my_votes(users('one'))
    # my_id = users('one').id
    # sql = "SELECT * FROM vote_proposals LEFT OUTER JOIN votes ON vote_proposals.id = votes.vote_proposal_id WHERE votes.user_id = #{my_id}"
    # records =  ActiveRecord::Base.connection.execute(sql)    
    # with_options = proposals.votes.with_options

    vps = VoteProposal.in_permitted_groups(users('one'))
    assert_equal vps.count, 1
    assert_equal vps.first.topic, "Ehdotus 1"

    
    vps = VoteProposal.global_or_permitted(users('one'))
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
