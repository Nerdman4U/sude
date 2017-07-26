require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  test 'should create persisted vote' do
    assert votes('one').persisted?
  end
  test 'should return array of options' do
    assert_equal votes('one').vote_proposal_options.count, 1
  end
end
