class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: { on_delete: :cascade, on_update: :cascade }
      t.references :vote_proposal, foreign_key: { on_delete: :cascade, on_update: :cascade }
      t.string :selected_options

      t.timestamps
    end
  end
end
