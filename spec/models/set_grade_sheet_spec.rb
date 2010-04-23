require 'spec_helper'

describe SetGradeSheet do
  describe "#retake?" do
    it "returns true if the user already has a grade associated with the exercise set" do
      set = Factory.create :complete_exercise_set
      u   = Factory.create :user
      set.set_grade_sheets.create! :grade=>90, :user=>u, :exercise_set=>set
      gs  = set.set_grade_sheets.create! :grade=>100, :user=>u, :exercise_set=>set
      gs.retake?.should == true
    end
    
    it "return false if there is no grade associated with the exercise set" do
      set = Factory.create :complete_exercise_set
      u   = Factory.create :user
      gs  = set.set_grade_sheets.create! :grade=>90, :user=>u, :exercise_set=>set
      gs.retake?.should == false
    end
  end
end
