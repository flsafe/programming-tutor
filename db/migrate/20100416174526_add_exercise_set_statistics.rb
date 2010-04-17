class AddExerciseSetStatistics < ActiveRecord::Migration
  def self.up
    add_column :exercise_sets, :average_grade, :float
    add_column :exercise_sets, :users_completed, :integer
  end

  def self.down
    remove_column :exercise_sets, :average_grade
    remove_column :exercise_set, :users_completed
  end
end
