class RemovePrimaryKeyFromExerciseSetsUsers < ActiveRecord::Migration
  def self.up
    remove_column :exercise_sets_users, :id
  end

  def self.down
  end
end
