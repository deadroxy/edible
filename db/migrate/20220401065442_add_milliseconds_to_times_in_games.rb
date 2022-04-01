class AddMillisecondsToTimesInGames < ActiveRecord::Migration[6.1]
  def change
    change_column :games, :started_at, :datetime, limit: 6
    change_column :games, :finished_at, :datetime, limit: 6
  end
end
