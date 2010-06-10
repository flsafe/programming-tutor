class AddGradeSheetIdToGradeSolutionResult < ActiveRecord::Migration
  def self.up
    add_column :grade_solution_results, :grade_sheet_id, :integer
  end

  def self.down
    remove_column :grade_solution_results, :grade_sheet_id
  end
end
