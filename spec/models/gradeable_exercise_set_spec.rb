require 'spec_helper'

describe GradeableExerciseSet do
  describe "#track_stats" do
    before(:each) do
      @exercise = Exercise.create! :title=>"@exercise", :description=>'d'
    end
    
    it "it tracks the cumulative average of the exercise when a user has completed it" do
      pending
      user = User.create! :username=>'frank', :email=>'user@mail.com', :password=>'password', :password_confirmation=>'password'
      exercise_set = ExerciseSet.create! :title=>"Basics", :description=>"d"
      ex1 = Exercise.create! :title=>"ex1", :description=>'d'
      ex2 = Exercise.create! :title=>'ex2', :description=>'d'
      exercise_set.exercises.<< ex1, ex2
      
      ex1.grade_sheets.create! :user=>user, :grade => 90.0, :gradeable=>ex1
      ex2.grade_sheets.create! :user=>user, :grade => 91.0, :gradeable=>ex2
      
      exercise_set.average_grade.should == 90.5
    end
  end
end