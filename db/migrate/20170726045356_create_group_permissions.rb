class CreateGroupPermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :group_permissions do |t|
      t.references :group, foreign_key: { on_delete: :cascade, on_update: :cascade }
      t.references :user, foreign_key: { on_delete: :cascade, on_update: :cascade }
      t.string :acl

      t.timestamps
    end
    add_index :group_permissions, [:group_id, :user_id], unique: true
  end
end
