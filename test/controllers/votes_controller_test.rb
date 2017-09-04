require 'test_helper'

class VotesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def teardown
    DatabaseCleaner.clean
  end
  
  test 'should create a vote and update counters' do
    user = create(:user)
    proposal = create(:vote_proposal, :with_options)
    sign_in user
    
    assert_difference 'Vote.count' do
      post create_vote_path, params: { vote: {
             vote_proposal_id: proposal.id,
             vote_proposal_option_ids: [proposal.vote_proposal_options.first.id]
           }}
    end
    vote = Vote.last
    assert_equal vote.vote_proposal_options.count, 1
    assert_equal vote.vote_proposal_options.first.name, proposal.vote_proposal_options.first.name
    assert_equal vote.send(:counter_values)[0][:a], 1
    assert_nil vote.send(:counter_values)[0][:c]
  end

  test 'should add multiple options to a vote' do
    proposal = create(:vote_proposal, :with_options)
    user = create(:user)
    vote = user.vote(proposal, proposal.vote_proposal_options.first)
    proposal.update_attributes(max_options: 2)    
    assert_equal vote.vote_proposal_options.count, 1
    assert_equal vote.vote_proposal.max_options, 2
    
    par = {
      vote: {
        vote_proposal_option_ids: [proposal.vote_proposal_options[1].id]
      }
    }

    sign_in user
    put update_vote_path(vote), params: par

    assert_equal vote.vote_proposal_options.count, 2
  end

  test 'should remove vote proposal option from a vote' do
    proposal = create(:vote_proposal, :with_options)
    user = create(:user)
    vote = user.vote(proposal, proposal.vote_proposal_options.first)
    option = vote.vote_proposal_options.first
    par = {
      vote: {
        vote_proposal_options_attributes: [{id: option.id, _destroy: true}]
      }
    }

    sign_in user
    put update_vote_path(vote), params: par
    
    vote.reload
    assert vote.vote_proposal_options.blank?
    assert_not vote.selected_options.match(option.name)
  end

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
