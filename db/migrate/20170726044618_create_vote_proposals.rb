class CreateVoteProposals < ActiveRecord::Migration[5.1]
  def change
    create_table :vote_proposals do |t|
      t.string :topic
      t.integer :min_options
      t.integer :max_options
      t.datetime :published_at
      t.datetime :viewable_at

      t.timestamps
    end
  end
end
