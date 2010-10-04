class GradeSheetsMustHaveTimeTaken < ActiveRecord::Migration
  def self.up
    GradeSheet.update_all('time_taken = 0', :time_taken=>nil)
  end

  def self.down
  end
end
