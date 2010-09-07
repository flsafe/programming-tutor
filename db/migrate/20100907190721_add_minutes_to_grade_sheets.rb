class AddMinutesToGradeSheets < ActiveRecord::Migration
  def self.up
    add_column :grade_sheets, :minutes, :integer
  end

  def self.down
    remove_column :grade_sheets, :minutes
  end
end
