class VoteProposalDescription < ActiveRecord::Migration[5.1]
  def change
    add_column :vote_proposals, :description, :text
  end
end
