require 'test_helper'

class GroupPermissionTest < ActiveSupport::TestCase
  def setup
    users('one').groups.clear
  end

  test 'should add default acl' do
    users('one').groups << groups('one')
    per = users('one').group_permissions.where(group_id: groups('one').id).first
    assert per.acl, "r"
  end
end
