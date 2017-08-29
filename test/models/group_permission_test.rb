require 'test_helper'

class GroupPermissionTest < ActiveSupport::TestCase
  def teardown
    DatabaseCleaner.clean
  end

  test 'should add default acl' do
    user = create(:user)
    group = create(:group)
    user.groups << group
    per = user.group_permissions.where(group_id: group.id).first
    assert per.acl, "r"
  end
end
