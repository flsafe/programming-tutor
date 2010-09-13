class CreatePerformanceStatistics < ActiveRecord::Migration
  def self.up
    create_table :performance_statistics do |t|
      t.integer :user_id
      t.integer :exercise_id
      t.string :name
      t.float :value
      
      t.timestamps
    end
  end

  def self.down
    drop_table :performance_statistics
  end
end
