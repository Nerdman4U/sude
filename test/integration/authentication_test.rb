require 'test_helper'

class AuthenticationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    Capybara.current_driver = :selenium # Capybara.javascript_driver # :selenium by default
  end

  test 'should find login link from langing page' do
    sign_out :user
    visit("/en")
    find_link('Sign in')
  end

  test 'should not find login link if signed in' do
    sign_in users(:one)
    visit("/en")
    assert_raise do
      find_link('Sign in')
    end
  end
  
end
