class CreateExerciseSetsUsers < ActiveRecord::Migration
  def self.up
    create_table :exercise_sets_users, :force=>true do |t|
      t.integer :exercise_set_id
      t.integer :user_id
    end
  end

  def self.down
    drop_table :exercise_sets_users
  end
end
