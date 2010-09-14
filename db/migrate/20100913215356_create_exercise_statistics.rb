class CreateExerciseStatistics < ActiveRecord::Migration
  def self.up
    create_table :exercise_statistics do |t|
      t.integer :exercise_id
      t.string :name
      t.float :value
    end
  end

  def self.down
    drop_table :exercise_statistics
  end
end
