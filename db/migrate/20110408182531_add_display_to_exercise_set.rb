class AddDisplayToExerciseSet < ActiveRecord::Migration
  def self.up
    add_column :exercise_sets, :display, :boolean
  end

  def self.down
    remove_column :exercise_sets, :display
  end
end
