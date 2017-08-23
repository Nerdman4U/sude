require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  def setup
    GroupPermission.delete_all
  end
  test 'should remove jointable record when user is removed' do
    # count = GroupPermission.where(user_id: users('one')).count

    # groups('one').users << users('one')
    # assert_equal GroupPermission.count, count + 1    
    # groups('one').destroy
    # assert_equal GroupPermission.count, count
  end

  test 'should have many vote proposals' do
    group = create(:group)
    assert group.vote_proposals
    assert group.group_vote_proposals
    group.vote_proposals << create(:vote_proposal)
    assert_equal group.vote_proposals.count, 1
  end
  
  test 'should create a group' do
    group = create(:group)
    assert group.persisted?
  end
end
