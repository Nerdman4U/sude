# coding: utf-8
require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  def setup
    @wrong_option = VoteProposalOption.new(name: "Tämä valinta on virheellinen")
  end

  def teardown
    DatabaseCleaner.clean
  end

  test 'should create user history when vote is created' do
    user = create(:user)
    proposal = create(:vote_proposal, :with_options)
    vote = create(:vote, user: user, vote_proposal: proposal, vote_proposal_options: [proposal.vote_proposal_options.first])
    assert_equal vote.user_histories.count, 1
  end

  test 'should not allow multiple votes for same user on proposal' do
    vote = create(:vote)
    proposal = vote.vote_proposal
    user = vote.user

    assert vote.valid?
    assert_no_difference 'Vote.count' do
      opt = proposal.vote_proposal_options.first
      params = {
        vote_proposal: proposal,
        user: user,
        vote_proposal_options: [opt]
      }
      vote = Vote.create(params)
    end
  end

  test 'should modify parametes' do
    proposal = create(:vote_proposal, max_options: 2)
    opt1 = create(:vote_proposal_option)
    opt2 = create(:vote_proposal_option)
    proposal.vote_proposal_options << [opt1, opt2]
    user = create(:user)
    vote = user.vote(proposal, [opt1,opt2])
    assert_equal vote.vote_proposal_options.count, 2
    
    params = {
      "vote_proposal_option_ids" => [{id: opt2.id}]
    }
    
    vote.modify_params! params
    assert_equal params["vote_proposal_option_ids"].count, 1
    assert_equal params["vote_proposal_option_ids"].first[:id], opt2.id
  end
  
  test 'should modify update parameters when proposal max_options is 2' do
    proposal = create(:vote_proposal)
    opt1 = create(:vote_proposal_option)
    opt2 = create(:vote_proposal_option)
    opt3 = create(:vote_proposal_option)
    proposal.vote_proposal_options << [opt1, opt2, opt3]
    user = create(:user)
    vote = user.vote(proposal, opt1)
    assert_equal vote.vote_proposal_options.count, 1
    
    vote.vote_proposal.update_attributes({max_options: 2})
    params = {
      "vote_proposal_option_ids" => [{id: opt2.id},{id: opt3.id}]
    }
    vote.modify_params! params
    assert_equal params["vote_proposal_option_ids"].count, 3
  end

  test 'should add multiple options to a vote' do
    proposal = create(:vote_proposal)
    opt1 = create(:vote_proposal_option)
    opt2 = create(:vote_proposal_option)
    opt3 = create(:vote_proposal_option)
    proposal.vote_proposal_options << [opt1, opt2, opt3]
    user = create(:user)
    vote = user.vote(proposal, opt1)
    
    params = {
      vote_proposal_option_ids: [opt1.id, opt2.id]
    }
    assert_equal vote.vote_proposal_options.count, 1
    vote.update_attributes!(params)
    assert_equal vote.vote_proposal_options.count, 2
    assert vote.vote_proposal_options.map(&:name).include?(opt1.name)
    assert vote.vote_proposal_options.map(&:name).include?(opt2.name)
  end

  test 'should delete a vote options with nested attributes' do
    user = create(:user)
    vote_proposal = create(:vote_proposal_with_options)
    opt = vote_proposal.vote_proposal_options.first    
    vote = user.vote(vote_proposal, opt)
    
    params = {
      vote_proposal_options_attributes: { id: opt.id, _destroy: true }
    }
    vote.update_attributes(params)
    assert_not vote.vote_proposal_options.include? opt
  end

  test 'should create a vote with nested attributes' do
    user = create(:user)
    user.vote_proposals.delete_all
    proposal = create(:vote_proposal_with_options)

    options = [proposal.vote_proposal_options.first.id]
    params = {
      vote_proposal_id: proposal.id,
      vote_proposal_option_ids: options,
      user_id: user.id
    }
    assert_difference "Vote.count" do
      Vote.create(params)
    end
  end
  
  test 'should create persisted vote' do
    vote = create(:vote)
    assert vote.persisted?
  end
  
  test 'should return array of options' do
    vote = create(:vote, :with_options)
    assert_equal vote.vote_proposal_options.count, 3
  end
  
  test 'should have correct string in selected_options attribute' do
    vote = create(:vote)
    option = create(:vote_proposal_option)
    vote.vote_proposal.vote_proposal_options << option
    vote.vote_proposal_options.clear
    vote.vote_proposal_options << option
    vote.save
    assert_equal vote.build_selected_options, vote.selected_options
  end
  
  test 'should raise if option is not found from proposal' do
    vote = create(:vote)
    vote.vote_proposal_options.clear
    
    proposal = vote.vote_proposal
    correct_options = proposal.vote_proposal_options

    vote.vote_proposal_options << @wrong_option
    assert_not vote.valid?
  end
  
  test 'should add an option if it is found from proposal' do
    vote = create(:vote)
    vote.vote_proposal_options.clear
    
    proposal = vote.vote_proposal
    correct_options = proposal.vote_proposal_options
    assert vote.vote_proposal_options << correct_options    
  end
  
  test 'should verify vote proposal options' do
    vote = create(:vote)
    assert vote.verify_vote_proposal_options
    vote.vote_proposal_options << @wrong_option
    assert_not vote.verify_vote_proposal_options
  end
  
  
end
