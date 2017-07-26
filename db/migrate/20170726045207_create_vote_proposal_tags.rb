class CreateVoteProposalTags < ActiveRecord::Migration[5.1]
  def change
    create_table :vote_proposal_tags do |t|
      t.string :name, index: { unique: true }

      t.timestamps
    end
  end
end
