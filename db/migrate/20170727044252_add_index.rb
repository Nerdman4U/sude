class AddIndex < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :email, unique: true
    add_index :groups, :name, unique: true
    add_index :vote_proposal_options, :name, unique: true
  end
end
