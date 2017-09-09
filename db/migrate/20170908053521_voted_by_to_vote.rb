class VotedByToVote < ActiveRecord::Migration[5.1]
  def change
    add_column :votes, :voted_by_id, :integer
  end
end
