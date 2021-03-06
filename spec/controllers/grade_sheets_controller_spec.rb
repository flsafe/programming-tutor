require 'spec_helper'

describe GradeSheetsController do

  describe "get show_user_grade_sheet" do
    
    before(:each) do
      @stub_exercise = stub_model(Exercise)
      @stub_current_user = stub_model(User)
      controller.stub(:current_user).and_return(@stub_current_user)
    end
    
    it "retrieves the associated exercise" do
      Exercise.should_receive(:find_by_id).with(@stub_exercise.id.to_s)
      get :show_user_grade_sheet, :id=>@stub_exercise.id
    end
    
    it "assigns the associated exercise" do
      Exercise.stub(:find_by_id).and_return(@stub_exercise)
      get :show_user_grade_sheet
      assigns[:exercise].should == @stub_exercise
    end
    
    it "retrevies the lastest grade sheet for the given exercise_id" do
      GradeSheet.should_receive(:find).with(:first, :conditions=>['exercise_id=? AND user_id=?', @stub_exercise.id.to_s, @stub_current_user.id], :order=>'created_at DESC')
      get :show_user_grade_sheet, :id=>@stub_exercise.id
    end
    
    it "assigns the grade sheet to be displayed" do
      stub_grade_sheet   = stub_model(GradeSheet)
      GradeSheet.stub(:find).and_return(stub_grade_sheet)
      
      get :show_user_grade_sheet, :id=>@stub_exercise.id
      assigns[:grade_sheet].should == stub_grade_sheet
    end
  end
  
end
