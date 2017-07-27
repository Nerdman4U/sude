class RemoveTimestampsFromJoinTables < ActiveRecord::Migration[5.1]
  def change
    remove_column :user_vote_proposals, :updated_at
    remove_column :user_vote_proposals, :created_at
    remove_column :vote_vote_proposal_options, :updated_at
    remove_column :vote_vote_proposal_options, :created_at
    remove_column :vote_proposal_vote_proposal_options, :updated_at
    remove_column :vote_proposal_vote_proposal_options, :created_at
  end
end
