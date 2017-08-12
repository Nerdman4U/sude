require 'test_helper'

class VotesControllerTest < ActionDispatch::IntegrationTest

  test 'should create a vote' do
    assert_difference 'Vote.count' do
      post create_vote_path, params: { vote: {
             vote_proposal_id: vote_proposals('one').id,
             vote_proposal_option_ids: [vote_proposal_options('one').id]
           }}
    end
    vote = Vote.last
    assert_equal vote.vote_proposal_options.count, 1
    assert_equal vote.vote_proposal_options.first.name, "no"
  end

  test 'should add multiple options to a vote' do
    vote = votes('one')
    vote.vote_proposal.update_attributes(max_options: 2)
    assert_equal vote.vote_proposal.max_options, 2

    par = {
      vote: {
        vote_proposal_option_ids: [vote_proposal_options('two').id]
      }
    }
    put update_vote_path(vote), params: par

    assert_equal vote.vote_proposal_options.count, 2
  end

  test 'should remove vote proposal option from a vote' do
    vote = votes('one')
    option = vote.vote_proposal_options.first
    par = {
      vote: {
        vote_proposal_options_attributes: [{id: option.id, _destroy: true}]
      }
    }
    put update_vote_path(vote), params: par
    
    assert vote.vote_proposal_options.blank?
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
