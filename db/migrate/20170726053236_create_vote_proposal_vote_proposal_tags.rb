class CreateVoteProposalVoteProposalTags < ActiveRecord::Migration[5.1]
  def change
    create_table :vote_proposal_vote_proposal_tags do |t|
      t.references :vote_proposal, foreign_key: { on_delete: :cascade, on_update: :cascade }, index: { name: "vopovopota_vopo_id" }
      t.references :vote_proposal_tag, foreign_key: { on_delete: :cascade, on_update: :cascade }, index: { name: "vopovopota_vopota_id" }
    end
  end
end
