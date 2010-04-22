require 'spec_helper'

describe GradeSheet do
  before(:each) do
    @user = User.create! :username=>'frank', :password=>'password', :password_confirmation=>'password', :email=>'user@mail.com'
    @ex1_set = ExerciseSet.create! :title=>"Basics", :description=>'d'
    @ex1 = Exercise.create! :title=>'ex1', :description=>'d'
    @ex2 = Exercise.create! :title=>'ex2', :description=>'d'
    @ex1_set.exercises.push(@ex1, @ex2)
  end
  
  describe "#retake?" do
    it "returns true if the @user has other grade sheets for the associated exercise" do
      @ex1.grade_sheets.create! :grade=>50, :user=>@user, :exercise=>@ex1
      gs = @ex1.grade_sheets.create! :grade=>51, :user=>@user, :exercise=>@ex1
      gs.retake?.should == true
    end
    
    it "returns false if the @user has only one grade sheet for the associated exercise" do
      gs = @ex1.grade_sheets.create! :grade=>50, :user=>@user, :exercise=>@ex1
      gs.retake?.should == false
      
      @user = User.create! :username=>'jim', :email=>'jim@mail.com', :password=>'password', :password_confirmation=>'password'
      gs = @ex1.grade_sheets.create! :grade=>50, :user=>@user, :exercise=>@ex1
      gs.retake?.should == false
    end
  end
  
  describe "#complete_set?" do
    it "return true if the there is a grade sheet for each exercise in the set" do
      @ex1.grade_sheets.create! :grade=>90.0, :user=>@user, :exercise=>@ex1
      gs = @ex2.grade_sheets.create! :grade=>91.0, :user=>@user, :exercise=>@ex2
      gs.complete_set?.should == true
    end
    
    it "returns false if the @user has not finished the exercise set" do
      gs = @ex1.grade_sheets.create! :grade=>90.0, :user=>@user, :exercise=>@ex1
      gs.complete_set?.should == false
      
      jim = User.create! :username=>'jim', :email=>'jim@mail.com', :password=>'password', :password_confirmation=>'password'
      gs = @ex1.grade_sheets.create! :grade=>90.0, :user=>jim, :exercise=>@ex1
      gs.complete_set?.should == false
    end
  end
  
  describe "#grades_in_set" do
    it "returns the grades associated with the exercise set" do
      gs = @ex1.grade_sheets.create! :grade=>90.0, :user=>@user, :exercise=>@ex1
      gs.grades_in_set.should == [90.0]
      gs = @ex1.grade_sheets.create! :grade=>100.0, :user=>@user, :exercise=>@ex2
      gs.grades_in_set.should == [90.0, 100.0]
    end
  end
end
