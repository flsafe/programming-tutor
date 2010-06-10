class AddTimeStampsToGradeSolutionResults < ActiveRecord::Migration
  def self.up
    add_column :grade_solution_results, :created_at, :timestamp
    add_column :grade_solution_results, :modified_at, :timestamp
  end

  def self.down
    remove_column :grade_solution_results, :created_at
    remove_column :grade_solution_results, :modified_at
  end
end
