class StatusToVote < ActiveRecord::Migration[5.1]
  def change
    add_column :votes, :status, :string
  end
end
