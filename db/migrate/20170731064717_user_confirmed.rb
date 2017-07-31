class UserConfirmed < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :confirmed, :integer
  end
end
