class DropSetGradeSheets < ActiveRecord::Migration
  def self.up
    drop_table :set_grade_sheets
  end

  def self.down
     create_table :set_grade_sheets, :force=>true do |t|
      t.integer :user_id
      t.integer :exercise_set_id
      
      t.float :grade
      
      t.timestamps
    end
  end
end
