class MandateUser < ActiveRecord::Migration[5.1]
  def change
    create_table :mandate_users do |t|
      t.integer :user_id
      t.integer :mandate_from_id
      t.integer :circle_id
      t.integer :order_number
    end
  end
end
