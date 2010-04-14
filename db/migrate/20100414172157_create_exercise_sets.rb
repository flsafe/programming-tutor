class CreateExerciseSets < ActiveRecord::Migration
  def self.up
    create_table :exercise_sets do |t|
      t.string :title
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :exercise_sets
  end
end
