# coding: utf-8
require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  def setup
    @wrong_option = VoteProposalOption.new(name: "Tämä valinta on virheellinen")
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
