require 'spec_helper'

describe GradeSheet do
  describe "#retake" do
     before(:each) do
      @exercise = Exercise.create! :title=>"@exercise", :description=>'d'
    end
    
    it "returns true if the user has other grade sheets for the associated exercise" do
      frank = User.create! :username=>'frank', :email=>'user@mail.com', :password=>'password', :password_confirmation=>'password'
      @exercise.grade_sheets.create! :grade=>50, :user=>frank, :gradeable=>@exercise
      gs = @exercise.grade_sheets.create! :grade=>51, :user=>frank, :gradeable=>@exercise
      gs.retake?.should == true
    end
    
    it "returns false if the user has only one grade sheet for the associated exercise" do
      user = User.create! :username=>'frank', :email=>'user@mail.com', :password=>'password', :password_confirmation=>'password'
      gs = @exercise.grade_sheets.create! :grade=>50, :user=>user, :gradeable=>@exercise
      
      gs.retake?.should == false
      
      user = User.create! :username=>'jim', :email=>'jim@mail.com', :password=>'password', :password_confirmation=>'password'
      gs = @exercise.grade_sheets.create! :grade=>50, :user=>user, :gradeable=>@exercise
      
      gs.retake?.should == false
    end
  end
end
