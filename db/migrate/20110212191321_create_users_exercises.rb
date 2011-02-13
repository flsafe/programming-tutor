class CreateUsersExercises < ActiveRecord::Migration
  def self.up
   create_table :users_exercises, :force=>true do |t|
    t.integer :user_id
    t.integer :exercise_id
   end
  end

  def self.down
    drop_table :users_exercises
  end
end
