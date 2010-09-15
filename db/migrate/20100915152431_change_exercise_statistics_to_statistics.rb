class ChangeExerciseStatisticsToStatistics < ActiveRecord::Migration
  def self.up
    add_column :exercise_statistics, :model_name, :string
    rename_table :exercise_statistics, :statistics
  end

  def self.down
    rename_table :statistics, :exercise_statistics
    remove_column :exercise_statistics, :model_name
  end
end
