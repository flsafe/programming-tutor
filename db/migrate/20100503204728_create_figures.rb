class CreateFigures < ActiveRecord::Migration
  def self.up
    create_table :figures, :force=>true do |t|
      t.integer :exercise_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :figures
  end
end
