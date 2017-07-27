require 'test_helper'

class VoteProposalOptionTest < ActiveSupport::TestCase
  test 'should not have | in the name' do
    opt = vote_proposal_options('one')
    opt.name = "yeah"
    assert opt.valid?
    opt.name = "yeah|"
    assert_not opt.valid?
  end
    
  test 'should create persisted vote_proposal option object' do
    assert vote_proposal_options('one').persisted?
  end  
end
