class UsernameToUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :ip
    add_column :users, :username, :string
    add_column :users, :fullname, :string
  end
end
