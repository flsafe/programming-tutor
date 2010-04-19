class AddStatsToExercises < ActiveRecord::Migration
  def self.up
    add_column :exercises, :users_completed, :integer
    add_column :exercises, :average_grade, :float
  end

  def self.down
    remove_column :exercises, :users_completed
    remove_column :exercises, :average_grade
  end
end
