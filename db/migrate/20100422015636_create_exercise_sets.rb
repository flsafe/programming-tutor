class CreateExerciseSets < ActiveRecord::Migration
  def self.up
    create_table :exercise_sets, :force=>true do |t|
      t.string :title
      t.string :description
      t.float :average_grade
      
      t.timestamps
    end
  end

  def self.down
    drop_table :exercise_sets
  end
end
