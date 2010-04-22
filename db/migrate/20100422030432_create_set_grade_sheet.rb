class CreateSetGradeSheet < ActiveRecord::Migration
  def self.up
    create_table :set_grade_sheets, :force=>true do |t|
      t.integer :user_id
      t.integer :exercise_set_id
      
      t.float :grade
      
      t.timestamps
    end
  end

  def self.down
    drop_table :set_grade_sheets
  end
end
