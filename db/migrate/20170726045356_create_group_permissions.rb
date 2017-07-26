class CreateGroupPermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :group_permissions do |t|
      t.references :group, foreign_key: { on_delete: :cascade, on_update: :cascade }
      t.references :user, foreign_key: { on_delete: :cascade, on_update: :cascade }
      t.string :acl

      t.timestamps
    end
  end
end
