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

  def teardown
    DatabaseCleaner.clean
  end

  test 'should return vote proposals in the groups user is' do
    group = create(:group, :with_proposals)
    user = create(:user)
    user.groups << group
    vps = VoteProposal.in_permitted_groups(user)
    assert_equal vps.count, 3
    assert vps.all? {|vp| vp.groups.count == 1 }
  end

  test 'should return global vote proposals' do
    proposal = create(:vote_proposal)
    vps = VoteProposal.global.to_a
    assert_equal vps.count, 1
  end
  
  test 'should return global proposals or proposals in the groups user is' do
    proposal = create(:vote_proposal)
    user = create(:user_with_group_with_proposals)
    vps = VoteProposal.global_or_permitted(user)
    assert_equal vps.count, 4

    valid_groups = user.groups
    assert vps.all? {|vp|
      vp.groups.blank? or vp.groups.any? {|group| valid_groups.include?(group)}
    }
    
  end
    
  test 'should find vote proposal with old and new slugged name' do
    vote_proposal = create(:vote_proposal)
    old_slug = vote_proposal.slug
    vote_proposal.topic = "foobar"
    vote_proposal.save
    assert_equal vote_proposal.friendly_id, old_slug # old name works

    old_slug = vote_proposal.slug
    vote_proposal.slug = nil
    vote_proposal.save
    assert vote_proposal.friendly_id.match(/foobar/) # new name works after regeneration

    assert VoteProposal.friendly.find("foobar")
    assert VoteProposal.friendly.find(old_slug)       
  end
  test 'should create persisted vote_proposal object' do
    vote_proposal = create(:vote_proposal)
    assert vote_proposal.persisted?
  end
  test 'should have an array of users' do
    #vote_proposal = create(:vote_proposal_with_users)
    #assert vote_proposal.users.count > 0
  end
  test 'should have an array of votes' do
    vote_proposal = create(:vote_proposal_with_votes)
    assert vote_proposal.votes.count > 0
  end
  test 'should have an array of groups' do
    vote_proposal = create(:vote_proposal_with_groups)
    assert vote_proposal.groups.count > 0
  end
  test 'should have an array of vote_proposal_tags' do
    vote_proposal = create(:vote_proposal_with_tags)
    assert vote_proposal.vote_proposal_tags.count > 0
  end
  test 'should have an array of vote_proposal_options' do
    vote_proposal = create(:vote_proposal_with_options)
    assert vote_proposal.vote_proposal_options.count > 0
  end
end
