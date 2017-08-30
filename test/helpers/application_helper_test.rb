require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  test 'should return select form options for adding group' do
    user = create(:user, groups: [create(:group)])
    opts = group_options(user.groups)
    assert opts.include? [user.groups.first.name, user.groups.first.id]
    assert opts.include? ["No group", nil]
  end

end
