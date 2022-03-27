class AddResponsesToGame < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :responses, :string
  end
end
