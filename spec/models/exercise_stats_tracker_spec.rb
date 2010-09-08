require 'spec_helper'

describe ExerciseStatsTracker do
  
  describe "#update_stats" do
    before(:each) do
      @user       = Factory.create :user
      @set        = Factory.create :complete_exercise_set
      @exercise1  = @set.exercises[0]
      @exercise2  = @set.exercises[1]
    end
    
   it "keeps a cumulative average of the exercise grades as grade sheets are added to the exercise" do
      grades = [30, 31, 32]
      grades.each do |g|
        gs = Factory.build :grade_sheet, :grade=>g, :exercise=>@exercise1
        @exercise1.grade_sheets << gs
      end
      @exercise1.average_grade.should == average(grades)
    end
    
    it "doesn't count retakes by the same user in the cumulative average for an exercise" do
      grades = [50, 51]
      grades.each do |g|
        gs = Factory.build :grade_sheet, :grade=>g, :user=>@user, :exercise=>@exercise1
        @exercise1.grade_sheets << gs
      end
      @exercise1.average_grade.should == average(grades)
    end
    
    def average(grades)
      grades.inject {|sum, g| sum + g} / grades.count
    end
  end
end
