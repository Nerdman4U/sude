require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  test 'should get settings' do
    user = create(:user)
    get settings_path(user, locale: :fi)
    assert_response :success
    get settings_path(user, locale: :en)
    assert_response :success
  end

  test 'should get history' do
    user = create(:user)
    get history_path(user, locale: :fi)
    assert_response :success
    get history_path(user, locale: :en)
    assert_response :success
  end
  
end
