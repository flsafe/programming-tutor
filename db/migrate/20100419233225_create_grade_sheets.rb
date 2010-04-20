class CreateGradeSheets < ActiveRecord::Migration
  def self.up
    create_table :grade_sheets, :force=>true do |t|
      t.integer :user_id
      t.integer :gradeable_id
      
      t.float :grade
      
      t.timestamps
    end
  end

  def self.down
    drop_table :grade_sheets
  end
end
