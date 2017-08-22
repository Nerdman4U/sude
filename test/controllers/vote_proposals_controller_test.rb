require 'test_helper'

class VoteProposalsControllerTest < ActionDispatch::IntegrationTest

  test 'should get index with group id' do
    group = create(:group)
    get vote_proposals_with_group_url group_id: group.id
    assert_response :success
  end

  test 'should set proposal ids to session' do
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
