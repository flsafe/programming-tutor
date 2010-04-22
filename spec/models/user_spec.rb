require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {
      :username => "frank",
      :password => "password",
      :password_confirmation => "password",
      :email => "user@mail.com"
    }
    @current_user = User.create! @valid_attributes
  end
  
  describe  "#grade_for" do
    before(:each) do
      @exercise = Exercise.create! :title=>"Linked List Basics", :description=>"description"
    end
    
    it "returns the grade for the associated exercise" do
      @exercise.grade_sheets.create! :grade=>92.1, :user=>@current_user, :exercise=>@exercise
      @current_user.grade_for?(@exercise).should == 92.1
    end
    
    it "returns the most recent grade" do
     GradeSheet.create! :grade=>60, :user=>@current_user, :exercise=>@exercise
     GradeSheet.create! :grade=>90, :user=>@current_user, :exercise=>@exercise
     sleep(1) #Make sure one is inserted at a later time
     GradeSheet.create! :grade=>100, :user=>@current_user, :exercise=>@exercise
     
     @current_user.grade_for?(@exercise).should == 100
    end
    
    it "returns nil if there is no grade sheet associated with the exercise" do
      @current_user.grade_for?(@exercise).should == nil
    end
  end
end
