class RemoveFigures < ActiveRecord::Migration
  def self.up
    drop_table :figures
  end
  
  def self.down
    create_table :figures, :force=>true do |t|
      t.integer :exercise_id
      
      t.timestamps
    end
  end
end
