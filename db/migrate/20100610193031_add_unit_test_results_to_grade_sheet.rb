class AddUnitTestResultsToGradeSheet < ActiveRecord::Migration
  def self.up
    add_column :grade_sheets, :unit_test_results, :text
    add_column :grade_sheets, :src_code, :text
  end

  def self.down
    remove_column :grade_sheets, :unit_test_results
    remove_column :grade_sheets, :src_code
  end
end
