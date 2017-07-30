ActiveAdmin.register GroupPermission do
  permit_params :acl, :user_id, :group_id
end
