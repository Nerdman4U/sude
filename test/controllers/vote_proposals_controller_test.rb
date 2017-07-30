require 'test_helper'

class VoteProposalsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get vote_proposals_index_url
    assert_response :success
  end

  test "should get show" do
    get vote_proposals_show_url
    assert_response :success
  end

end
