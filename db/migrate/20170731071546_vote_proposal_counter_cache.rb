class VoteProposalCounterCache < ActiveRecord::Migration[5.1]
  def change
    add_column :vote_proposal_vote_proposal_options, :anonymous_vote_count, :integer
    add_column :vote_proposal_vote_proposal_options, :confirmed_vote_count, :integer
  end
end
