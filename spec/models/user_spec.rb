require 'spec_helper'

describe User do
  
  describe  "#grade_for" do
    
    before(:each) do
        @current_user = Factory.create :user
        @exercise_set = Factory.create :complete_exercise_set
        @exercise = @exercise_set.exercises[0]
    end
    
    context "when given an exercise" do
      it "returns the grade for the associated exercise" do
        @exercise.grade_sheets.create!(Factory.build(:grade_sheet, :grade=>92.1, :user=>@current_user, :exercise=>@exercise).attributes)
        @current_user.grade_for?(@exercise).should == 92.1
      end
    
      it "returns the most recent grade" do
       Factory.create :grade_sheet, :grade=>60, :user=>@current_user, :exercise=>@exercise
       Factory.create :grade_sheet, :grade=>90, :user=>@current_user, :exercise=>@exercise
       sleep(1) #Make sure one is inserted at a later time
       GradeSheet.create!(Factory.build(:grade_sheet, :grade=>100, :user=>@current_user, :exercise=>@exercise).attributes)
       @current_user.grade_for?(@exercise).should == 100
      end
    
      it "returns nil if there is no grade sheet associated with the exercise" do
        @current_user.grade_for?(@exercise).should == nil
      end
    end
    
    context "when given an exercise set" do
      it "returns the average grade for the associated exercise set" do
        @exercise_set.set_grade_sheets.create! Factory.build(:set_grade_sheet, :grade=>91.1, :user=>@current_user, :exercise_set=>@exercise_set).attributes
        @current_user.grade_for?(@exercise_set).should == 91.1
      end
    end
  end
end
