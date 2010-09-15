class RenameStatsColumnExerciseIdToModelId < ActiveRecord::Migration
  def self.up
    rename_column :statistics, :exercise_id, :model_id
  end

  def self.down
    rename column :statistics, :model_id, :exercise_id
  end
end
