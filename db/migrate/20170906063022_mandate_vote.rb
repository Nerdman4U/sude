class MandateVote < ActiveRecord::Migration[5.1]
  def change
    create_table :mandate_votes do |t|
      t.integer :vote_id
      t.integer :mandate_from_id
    end
  end
end
