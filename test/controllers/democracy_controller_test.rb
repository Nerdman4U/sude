require 'test_helper'

class DemocracyControllerTest < ActionDispatch::IntegrationTest
  test 'should route instruction' do
    assert_routing '/en/instruction', controller: "democracy", action: "instruction", locale: "en"
  end
  
  test 'should show instruction' do
    get "/en/instruction"
    assert_response :success

    get "/fi/ohje"
    assert_response :success
  end
  
end
