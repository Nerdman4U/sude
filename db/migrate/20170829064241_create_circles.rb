class CreateCircles < ActiveRecord::Migration[5.1]
  def change
    create_table :circles do |t|
      t.string :name
      t.integer :group_id
      t.integer :parent_id
      t.datetime :published_at

      t.timestamps
    end
  end
end
