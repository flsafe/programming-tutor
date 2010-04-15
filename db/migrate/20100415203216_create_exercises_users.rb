class CreateExercisesUsers < ActiveRecord::Migration
  def self.up
    create_table :exercises_users, :id=>false do |t|
      t.integer :exercise_id
      t.integer :user_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :exercise_users
  end
end
