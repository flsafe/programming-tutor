class CreateExerciseSessions < ActiveRecord::Migration
  def self.up
    create_table :exercise_sessions, :force=>true do |t|
      t.integer :user_id
      t.integer :exercise_id
      t.timestamp :start_time
      t.timestamps
    end
  end

  def self.down
    drop_table :exercise_sessions
  end
end
