class VoteProposalSlug < ActiveRecord::Migration[5.1]
  def change
    add_column :vote_proposals, :slug, :string, uniq: true
  end
end
