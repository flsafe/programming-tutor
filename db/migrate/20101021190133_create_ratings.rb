class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings, :force=>true do |t|
      t.integer :user_id
      t.integer :exercise_id
      t.float :rating

      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end
