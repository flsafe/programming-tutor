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
      @set = ExerciseSet.create! :title=>"Linked List Basics", :description=>"description"
    end
    
    it "returns the grade for the associated exercise set" do
      pending "need to refactore the stats hiearchy" do
        @set.grade_sheets.create! :grade=>92.1, :user=>@current_user, :gradeable=>@set
        @current_user.grade_for?(@set).should == 92.1
      end
    end
    
    it "returns the most recent grade" do
     GradeSheet.create! :grade=>60, :user=>@current_user, :gradeable=>@set
     GradeSheet.create! :grade=>90, :user=>@current_user, :gradeable=>@set
     sleep(1) #Make sure one is inserted at a later time
     GradeSheet.create! :grade=>100, :user=>@current_user, :gradeable=>@set
     
     @current_user.grade_for?(@set).should == 100
    end
    
    it "returns nil if there is no grade sheet associated with the exercise set" do
      @current_user.grade_for?(@set).should == nil
    end
  end
end
