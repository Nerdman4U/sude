require 'test_helper'

class VotesControllerTest < ActionDispatch::IntegrationTest
  test 'should route root url to default locale index' do
    get root_url
    assert_redirected_to "/fi"
    # assert_routing '/', controller: "votes", action: "index"
  end

  test 'should show index' do
    get "/fi"
    assert_response :success
  end

end
