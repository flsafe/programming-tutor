class CreateGradeSheets < ActiveRecord::Migration
  def self.up
    create_table :grade_sheets do |t|
      t.integer :user_id
      t.integer :resource_id
      t.string :resource_type
      
      t.float :grade
      
      t.timestamps
    end
  end

  def self.down
    drop_table :grade_sheets
  end
end
