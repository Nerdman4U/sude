class CreateUserHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :user_histories do |t|
      t.column :vote_id, :integer
      t.timestamps
    end
  end
end
