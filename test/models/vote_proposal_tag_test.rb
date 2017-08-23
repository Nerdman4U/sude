require 'test_helper'

class VoteProposalTagTest < ActiveSupport::TestCase

  test 'should have many vote proposals' do
    tag = create(:vote_proposal_tag)
    assert tag.vote_proposals
    assert tag.vote_proposals << create(:vote_proposal)
  end
end
