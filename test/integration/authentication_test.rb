# coding: utf-8
require 'test_helper'

class AuthenticationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    Capybara.current_driver = :selenium # Capybara.javascript_driver # :selenium by default
    DatabaseCleaner.clean
  end
  
  def setup_mobile
    Capybara.register_driver :chrome320x480 do |app|
      args = []
      args << "--window-size=320,480"
      # you can also set the user agent 
      # args << "--user-agent='Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3'"
      Capybara::Selenium::Driver.new(app, :browser => :chrome, :args => args)
    end
    Capybara.current_driver = :chrome320x480    
    DatabaseCleaner.clean
  end

  def teardown
  end

  test 'should find login link from langing page' do
    sign_out :user
    visit("/en")
    #find_link('Sign in')
  end

  test 'should not find login link if signed in' do
    sign_in create(:user)
    visit("/en")
    assert_raise do
      find_link('Sign in')
    end
  end

  test 'should render proposal index correctly with mobile' do
    setup_mobile
    proposal = create(:vote_proposal, :with_options, published_at: Time.now - 1.day)
    user = create(:user)
    user.vote proposal, proposal.vote_proposal_options.first
    sign_in user
    visit("/fi")
    proposals = page.all(:css, 'article.proposal')
    assert_equal proposals.size, 1
    a_count = proposals.first.all('td.anonymous_count')
    c_count = proposals.first.all('td.confirmed_count')
    assert a_count.first
    assert c_count.first
    assert_equal a_count.first.text, "1"
    assert_equal c_count.first.text, "0"
  end
  
end
