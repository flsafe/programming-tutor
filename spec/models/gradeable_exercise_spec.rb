require 'spec_helper'

describe GradeableExercise do
  
  describe "#track_stats" do
    before(:each) do
      @exercise = Exercise.create! :title=>"@exercise", :description=>'d'
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
  end
end