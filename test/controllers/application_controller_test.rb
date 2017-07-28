require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test 'should set locale' do
    get "/fi"
    # assert_equal I18n.locale, "fi"
  end
  
end
