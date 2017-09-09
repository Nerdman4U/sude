class SelectedOptionsToUserHistory < ActiveRecord::Migration[5.1]
  def change
    add_column :user_histories, :selected_options, :string
  end
end
