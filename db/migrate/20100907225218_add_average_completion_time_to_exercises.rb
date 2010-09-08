class AddAverageCompletionTimeToExercises < ActiveRecord::Migration
  def self.up
    add_column :exercises, :average_seconds, :integer
  end

  def self.down
    remove_column :exercises, :average_seconds, :integer
  end
end
