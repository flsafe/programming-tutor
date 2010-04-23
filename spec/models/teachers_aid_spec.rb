require 'spec_helper'

describe TeachersAid do
  
  describe "#record_grade" do
    before(:each) do
      @ta              = TeachersAid.new
      @grade_sheets    = mock("GradeSheetsCollection")
      @ex              = stub_model(Exercise, :grade_sheets=>@grade_sheets)
      @set             = stub_model(ExerciseSet, :exercises=>[@ex]) 
      @ex.exercise_set = @set
      @gs              = stub_model(GradeSheet, :user=>stub_model(User), :grade=>90, :exercise=>@ex)
    end
    
    it "adds a new grade sheet to the associated exercise" do
      @grade_sheets.should_receive(:<<).with(@gs)
      @ta.record_grade(@gs)
    end
    
    it "adds a new grade sheet to the exercise set when it is completed" do
      set = Factory.create :complete_exercise_set
      u   = Factory.create :user
      @ta.record_grade Factory.create :grade_sheet, :user=>u, :exercise=>set.exercises[0]
      @ta.record_grade Factory.create :grade_sheet, :user=>u, :exercise=>set.exercises[1]
      set.reload
      set.average_grade.should == 100
      set.set_grade_sheets.count.should == 1
    end
    
    it "it does not record a set average unless the set is completed by the user" do
      set = Factory.create :complete_exercise_set
      u   = Factory.create :user
      @ta.record_grade Factory.create :grade_sheet, :user=>u, :exercise=>set.exercises[0]
      set.reload
      set.average_grade.should == nil
      set.set_grade_sheets.count.should == 0
    end
  end
end