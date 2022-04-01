class AddScoreDurationToGame < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :score, :integer
    add_column :games, :duration, :float
  end
end
