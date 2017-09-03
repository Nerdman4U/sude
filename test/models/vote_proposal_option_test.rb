require 'test_helper'

class VoteProposalOptionTest < ActiveSupport::TestCase

  test 'should return preview options' do
    VoteProposalOption.delete_all
    options = VoteProposalOption.preview_options
    assert options.map(&:name).include? "Accept"
    assert options.map(&:name).include? "Decline"
    assert_equal options.size, 2

    options = VoteProposalOption.preview_options
    assert options.map(&:name).include? "Accept"
    assert options.map(&:name).include? "Decline"
    assert_equal options.size, 2

    assert_equal VoteProposalOption.all.size, 2    
  end
  
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
