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
  
  test 'should create a group' do
    assert groups('one').persisted?
  end
end
