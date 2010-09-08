class AddTimeTakenToGradeSheets < ActiveRecord::Migration
  def self.up
    add_column :grade_sheets, :time_taken, :integer
  end

  def self.down
    remove_column :grade_sheets, :time_taken
  end
end
