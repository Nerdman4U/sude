require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  test 'should get settings' do
    user = create(:user)
    sign_in user
    
    get settings_path
    assert_response :success
    
    get settings_path(locale: :en)
    assert_response :success
  end

  test 'should get history' do
    user = create(:user)
    sign_in user

    get history_path
    assert_response :success

    get history_path(locale: :en)
    assert_response :success
  end
  
end
