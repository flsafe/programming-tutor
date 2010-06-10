class CreateGradeSolutionResults < ActiveRecord::Migration
  def self.up
    create_table :grade_solution_results, :force=>true do |t|
      t.integer :user_id
      t.integer :exercise_id
      t.text    :error_message
    end
  end

  def self.down
    drop_table :grade_solution_results
  end
end
