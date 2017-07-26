class CreateVoteProposalOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :vote_proposal_options do |t|
      t.string :name

      t.timestamps
    end
  end
end
