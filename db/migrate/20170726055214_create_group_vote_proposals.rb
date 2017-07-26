class CreateGroupVoteProposals < ActiveRecord::Migration[5.1]
  def change
    create_table :group_vote_proposals do |t|
      t.references :group, foreign_key: { on_delete: :cascade, on_update: :cascade }
      t.references :vote_proposal, foreign_key: { on_delete: :cascade, on_update: :cascade }

      t.timestamps
    end
  end
end
