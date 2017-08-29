class UserUserHistory < ActiveRecord::Migration[5.1]
  def change
    create_table :user_user_histories do |t|
      t.column :user_id, :integer
      t.column :user_history_id, :integer
    end
  end
end
