require 'spec_helper'

describe GradeableExercise do
  
  describe "#track_stats" do
    before(:each) do
      @exercise = Exercise.create! :title=>"exercise", :description=>'d'
      ExerciseSet.create! :title=>'set', :description=>'d', :exercises=>[@exercise]
    end
    
    it "keeps a cumulative average of the exercise as users complete the exercise" do
      grades = [30, 31, 11.1, 0.0001, 1000.1]
      0.upto(grades.count-1) do |n|
        user = User.create! :username=>"user#{n}", :email=>"user#{n}@mail.com", :password=>'password', :password_confirmation=>'password'
        @exercise.grade_sheets.create! :grade=>grades[n], :user=>user, :gradeable=>@exercise
      end
      @exercise.average_grade.should == grades.inject {|sum, g| sum + g} / grades.count
    end
    
    it "doesn't count retakes by the same user in the cumulative average for an exercise" do
      user = User.create! :username=>'frank', :email=>'user@mail.com', :password=>'password', :password_confirmation=>'password'
      @exercise.grade_sheets.create! :grade=>50, :user=>user, :gradeable=>@exercise
      @exercise.grade_sheets.create! :grade=>51, :user=>user, :gradeable=>@exercise
      @exercise.average_grade.should == 50
    end
    
    it "it tracks the cumulative average of the exercise_associated exercise set when a user has completed it" do
      pending("Get the exercise set tracking fixed") do
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
end