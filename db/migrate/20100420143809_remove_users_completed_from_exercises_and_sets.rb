class RemoveUsersCompletedFromExercisesAndSets < ActiveRecord::Migration
  def self.up
    remove_column :exercise_sets, :users_completed
    remove_column :exercises, :users_completed
  end

  def self.down
    add_column :exercise_sets, :users_completed, :integer
    add_column :exercises, :users_completed, :integer
  end
end
