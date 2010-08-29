class CreateJobResults < ActiveRecord::Migration
  def self.up
    create_table :job_results do |t|
      t.integer :user_id
      t.integer :exercise_id
      t.string :job_type
      t.string :data
      t.string :error_message

      t.timestamps
    end
  end

  def self.down
    drop_table :job_results
  end
end
