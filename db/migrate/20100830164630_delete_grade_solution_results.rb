class DeleteGradeSolutionResults < ActiveRecord::Migration
  def self.up
    drop_table :grade_solution_results
  end

  def self.down
    create_table :grade_solution_results, :force=>true do |t|
      t.integer :user_id
      t.integer :exercise_id
      t.text    :error_message
    end
  end
end
