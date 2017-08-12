# coding: utf-8
require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  def setup
    @wrong_option = VoteProposalOption.new(name: "Tämä valinta on virheellinen")
  end

  test 'should refactor update parametes' do
    opt1 = vote_proposal_options('one')
    opt2 = vote_proposal_options('two')
    vote = users('one').votes.first
    assert_equal vote.vote_proposal_options.count, 1
    assert_equal vote.vote_proposal_options.first.name, "no"
    params = {
      "vote_proposal_option_ids" => [{id: opt2.id}]
    }
    vote.refactor_params! params
    assert_equal params["vote_proposal_option_ids"].count, 1
    assert_equal params["vote_proposal_option_ids"].first[:id], opt2.id
  end
  
  test 'should refactor update parameters when proposal max_options is 2' do    
    vote.vote_proposal.update_attributes({max_options: 2})
    params = {
      "vote_proposal_option_ids" => [{id: opt2.id}]
    }
    vote.refactor_params! params
    assert_equal params["vote_proposal_option_ids"].count, 2
    assert_equal params["vote_proposal_option_ids"][0][:id], opt2.id
    assert_equal params["vote_proposal_option_ids"][1][:id], opt1.id        
  end

  test 'should add multiple options to a vote' do
    vote = users('one').votes.first
    vote_proposal = vote.vote_proposal
    vote_option = vote.vote_proposal_options.first
    
    params = {
      vote_proposal_option_ids: [vote_proposal_options('one').id, vote_proposal_options('two').id]
    }
    assert_equal vote.vote_proposal_options.count, 1
    vote.update_attributes!(params) 
    assert_equal vote.vote_proposal_options.first.name, vote_option.name
    assert_equal vote.vote_proposal_options.count, 2
  end

  test 'should delete a vote options with nested attributes' do
    vote = users('one').votes.first
    vote_proposal = vote.vote_proposal
    vote_option = vote.vote_proposal_options.first
    
    params = {
      vote_proposal_options_attributes: { id: vote_option.id, _destroy: true }
    }
    assert vote.vote_proposal_options.include? vote_option
    vote.update_attributes(params)
    assert_not vote.vote_proposal_options.include? vote_option    
  end

  test 'should create a vote with nested attributes' do
    users('one').vote_proposals.delete_all

    options = [vote_proposals('one').vote_proposal_options.first.id]
    params = {
      vote_proposal_id: vote_proposals('one').id,
      vote_proposal_option_ids: options,
      user_id: users('one').id
    }
    assert_difference "Vote.count" do
      Vote.create(params)
    end
  end
  
  test 'should create persisted vote' do
    assert votes('one').persisted?
  end
  
  test 'should return array of options' do
    assert_equal votes('one').vote_proposal_options.count, 1
  end
  
  test 'should have correct string in selected_options attribute' do
    votes('one').vote_proposal.vote_proposal_options << vote_proposal_options('three')    
    votes('one').vote_proposal_options.clear
    votes('one').vote_proposal_options << vote_proposal_options('three')    
    votes('one').save
    assert_equal votes('one').build_selected_options, votes('one').selected_options
  end
  
  test 'should raise if option is not found from proposal' do
    vote = votes('one')
    vote.vote_proposal_options.clear
    
    proposal = votes('one').vote_proposal
    correct_options = proposal.vote_proposal_options

    vote.vote_proposal_options << @wrong_option
    assert_not vote.valid?
  end
  
  test 'should add an option if it is found from proposal' do
    vote = votes('one')
    vote.vote_proposal_options.clear
    
    proposal = votes('one').vote_proposal
    correct_options = proposal.vote_proposal_options
    assert vote.vote_proposal_options << correct_options    
  end
  
  test 'should verify vote proposal options' do
    assert votes('one').verify_vote_proposal_options
    votes('one').vote_proposal_options << @wrong_option
    assert_not votes('one').verify_vote_proposal_options
  end
  
  
end
