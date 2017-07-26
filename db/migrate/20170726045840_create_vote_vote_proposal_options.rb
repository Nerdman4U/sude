class CreateVoteVoteProposalOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :vote_vote_proposal_options do |t|
      t.references :vote, foreign_key: true
      t.references :vote_proposal_option, foreign_key: { on_delete: :cascade, on_update: :cascade }

      t.timestamps
    end
  end
end
