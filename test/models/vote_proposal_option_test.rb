require 'test_helper'

class VoteProposalOptionTest < ActiveSupport::TestCase
  test 'should not have | in the name' do
    opt = create(:vote_proposal_option)
    opt.name = "yeah"
    assert opt.valid?
    opt.name = "yeah|"
    assert_not opt.valid?
  end
    
  test 'should create persisted vote_proposal option object' do
    assert create(:vote_proposal_option).persisted?
  end  
end
