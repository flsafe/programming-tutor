require 'spec_helper'

describe ExerciseSetStatsTracker do
  before(:each) do
      @user      = Factory.create :user
      @set       = Factory.create :complete_exercise_set
      @exercise1 = @set.exercises[0]
      @exercise2 = @set.exercises[1]
  end
  
  it "it tracks the cumulative average of the exercise set" do
    grades = [90.0, 91.0, 81.1, 0.001]
    @set.set_grade_sheets << Factory.build(:set_grade_sheet, :grade=>average(grades), :exercise_set=>@set)
    @set.average_grade.should == average(grades)
  end
  
  it "it does not count retakes of the exercise set" do
    grades    = [90.0, 91.0, 81.1, 0.001]
    grades.each do |g|
      @set.set_grade_sheets << Factory.build(:set_grade_sheet, :grade=>g, :user=>@user, :exercise_set=>@set)
    end
    @set.reload
    @set.average_grade.should == 90
  end
  
  def average(grades)
      grades.inject {|sum, g| sum + g} / grades.count
  end
end
