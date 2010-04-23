require 'spec_helper'

describe TeachersAid do
  
  describe "#record_grade" do
    before(:each) do
      @user = Factory.create :user
      @ta   = TeachersAid.new
      @set   = Factory.create :complete_exercise_set
      @exercise1  = @set.exercises[0]
      @exercise2 = @set.exercises[1]
    end
    
    it "keeps a cumulative average of the exercise as users complete the exercise" do
      grades = [30, 31, 32]
      grades.each do |g|
        @ta.record_grade(Factory.build :grade_sheet, :grade=>g, :exercise=>@exercise1)
      end
      @exercise1.average_grade.should == average(grades)
    end
    
    it "doesn't count retakes by the same user in the cumulative average for an exercise" do
      grades = [50, 51]
      grades.each do |g|
        @ta.record_grade(Factory.build :grade_sheet, :grade=>g, :user=>@user, :exercise=>@exercise1)
      end
      @exercise1.average_grade.should == average(grades)
    end
    
    it "it tracks the cumulative average of the exercise set when a user has completed it" do
      grades    = [90.0, 91.0]
      exercises = [@exercise1, @exercise2]
      grades.zip(exercises) do |g, e|
        @ta.record_grade(Factory.build :grade_sheet, :grade=>g, :user=>@user, :exercise=>e)
      end
      @set.reload
      @set.average_grade.should == average(grades)
    end
    
    it "it does not record a set average unless the set is completed by the user" do
      grades    = [90.0]
      exercises = [@exercise1]
      grades.zip(exercises) do |g, e|
        @ta.record_grade(Factory.build :grade_sheet, :grade=>g, :user=>@user, :exercise=>e)
      end
      @set.reload
      @set.average_grade.should == nil
    end
    
    def average(grades)
      grades.inject {|sum, g| sum + g} / grades.count
    end
  end
end