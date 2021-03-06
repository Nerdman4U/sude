require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  # TODO: do this later when needed.
  test 'should have correct votes before and after sign up' do
    # user1 = create(:guest_user)
    # do voting here, as anonymous
    
    params = {
      email: "test@test.com",
      username: "foobar",
      password: "password"
    }
    # post new_user_registration_path(params)
    # ...votes should have been transferred to registered user.
  end

  test 'should patch mandate' do
    user1 = create(:user)
    user2 = create(:user)
    sign_in user2
    
    patch give_mandate_path(mandate_to_id: user1.id)
    assert_response :redirect

    patch remove_mandate_path(mandate_from_id: user1.id)
    assert_response :redirect
  end
  
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
