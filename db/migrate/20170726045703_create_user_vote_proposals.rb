class CreateUserVoteProposals < ActiveRecord::Migration[5.1]
  def change
    create_table :user_vote_proposals do |t|
      t.references :user, foreign_key: { on_delete: :cascade, on_update: :cascade }
      t.references :vote_proposal, foreign_key: { on_delete: :cascade, on_update: :cascade }
    end
  end
end
