class CreateUnitTest < ActiveRecord::Migration
  def self.up
    create_table :unit_tests, :force=>true do |t|
      t.integer :exercise_id
      
      t.string :src_language
      t.text :src_code
      
      t.timestamps
    end
  end

  def self.down
    drop_table :unit_tests
  end
end
