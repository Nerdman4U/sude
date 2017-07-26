class CreateVoteProposalVoteProposalOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :vote_proposal_vote_proposal_options do |t|
      t.references :vote_proposal, foreign_key: { on_delete: :cascade, on_update: :cascade }, index: { name: "vopovopoop_vopo_id" }
      t.references :vote_proposal_option, foreign_key: { on_delete: :cascade, on_update: :cascade }, index: { name: "vopovopoop_vopoop_id" }

      t.timestamps
    end
  end
end
