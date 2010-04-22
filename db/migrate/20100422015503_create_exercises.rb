class CreateExercises < ActiveRecord::Migration
  def self.up
    create_table :exercises, :force=>true do |t|
      t.integer :exercise_set_id
      
      t.string :title
      t.string :description
      t.float :average_grade
      
      t.timestamps
    end
  end

  def self.down
    drop_table :Exercises
  end
end
