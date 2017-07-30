class GroupPermission < ApplicationRecord
  belongs_to :user
  belongs_to :group

  after_initialize :defaults_for_new
  
  def defaults_for_new
    self.acl = "" if acl.blank?
  end
end
