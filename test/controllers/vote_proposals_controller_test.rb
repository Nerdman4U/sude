require 'test_helper'

class VoteProposalsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def teardown
    DatabaseCleaner.clean
  end

  # Preview is used for to be able to publish unpublished vote_proposals
  test 'should get preview' do
    proposal = create(:vote_proposal)
    get preview_vote_proposal_url(proposal)
    assert_response :success
  end

  test 'should create proposal' do
    user = create(:user)
    sign_in user
    circle = create(:circle)
    assert_difference "VoteProposal.count" do      
      post create_vote_proposal_url(vote_proposal: {
                                      topic:"foobar1", description:"asdf", circle_id:circle.id
                                    })
    end
    assert_redirected_to vote_proposal_path(VoteProposal.last)

    opt1 = create(:vote_proposal_option)
    opt2 = create(:vote_proposal_option)
    assert_difference "VoteProposal.count" do      
      post create_vote_proposal_url(vote_proposal: {
                                      topic:"foobar2", description:"asdf",
                                      circle_id:circle.id,
                                      vote_proposal_option_ids: [opt1.id, opt2.id]
                                    })
    end
    assert_redirected_to vote_proposal_path(VoteProposal.last)
    assert_equal VoteProposal.last.vote_proposal_options.size, 2
  end

  test 'get new vote proposal with a circle' do
    user = create(:user)
    sign_in user
    circle = create(:circle)
    get new_vote_proposal_url(circle)
    assert_response :success
  end

  test 'should get index with group id' do
    group = create(:group)
    get vote_proposals_with_group_url group_id: group.id
    assert_response :success
  end

  test 'should set proposal ids to session' do
    proposal = create(:vote_proposal)
    get vote_proposals_url
    handler = controller.send(:session_handler)
    list = handler.get(:proposals)
    assert list.is_a? Array
    assert list.count > 0
  end

  test 'should set current proposal id to session' do
    proposal = create(:vote_proposal)
    get vote_proposal_url(proposal)
    handler = controller.send(:session_handler)
    assert handler.get([:proposals, :current])    
  end
  
  test 'should get next proposal id from session' do
    proposal = create(:vote_proposal)
    get vote_proposals_url
    handler = controller.send(:session_handler)
    get vote_proposal_url(proposal)
    assert controller.send(:next_proposal_from_session)   
  end
  
  test 'should get previous proposal id from session' do
    proposal = create(:vote_proposal)
    get vote_proposals_url
    get vote_proposal_url(proposal)
    assert controller.send(:previous_proposal_from_session)
  end
      
  test "should get index" do
    get vote_proposals_url
    assert_response :success
  end

  test "should get show" do
    proposal = create(:vote_proposal)
    get vote_proposal_url(proposal)
    assert_response :success
  end

end
