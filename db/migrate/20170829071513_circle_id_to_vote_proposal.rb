class CircleIdToVoteProposal < ActiveRecord::Migration[5.1]
  def change
    add_column :vote_proposals, :circle_id, :integer
  end
end
