class RenameUserExercises < ActiveRecord::Migration
  def self.up
    rename_table :users_exercises, :exercises_users
  end

  def self.down
    rename_table :exercises_users, :users_exercises
  end
end
