require 'test_helper'

class VoteProposalsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get vote_proposals_url
    assert_response :success
  end

  test "should get show" do
    get vote_proposal_url(vote_proposals('one'))
    assert_response :success
  end

end
