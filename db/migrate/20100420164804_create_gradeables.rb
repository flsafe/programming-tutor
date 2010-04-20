class CreateGradeables < ActiveRecord::Migration
  def self.up
    create_table :gradeables, :force=>true do |t|
      t.string :type
      t.integer :belongs_to
      
      #Common
      t.string :title
      t.string :description
      
      t.float :average_grade
      
      t.timestamps
    end
  end

  def self.down
    drop_table :gradables
  end
end
