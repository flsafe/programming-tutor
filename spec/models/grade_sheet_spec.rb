require 'spec_helper'

describe GradeSheet do
  before(:each) do
    @user         = Factory.create :user
    @exercise_set = Factory.create :complete_exercise_set
    @exercise_set.exercises.each {|e| e.update_attributes :exercise_set=>@exercise_set}
    @ex1, @ex2    = @exercise_set.exercises[0], @exercise_set.exercises[1]
  end
  
  def code
    @src_code ||= "int main(){return 0;}"
  end
  
  def results
    @results ||= "{test1=>'20'}"
  end
  
  describe "#retake?" do
    
    it "returns true if the user has other grade sheets for the associated exercise" do
      gs = nil
      [50, 51].each do | g |
        gs = @ex1.grade_sheets.create!(Factory.build(:grade_sheet, :grade=>g, :user=>@user, :exercise=>@ex1).attributes)
      end
      gs.retake?.should == true
    end
    
    it "returns false if the user has only one grade sheet for the associated exercise" do
      gs = @ex1.grade_sheets.create!(Factory.build(:grade_sheet, :grade=>50, :user=>@user, :exercise=>@ex1).attributes)
      gs.retake?.should == false
      
      @user = Factory.create :user
      gs = @ex1.grade_sheets.create!(Factory.build(:grade_sheet, :grade=>50, :user=>@user, :exercise=>@ex1).attributes)
      gs.retake?.should == false
    end
  end

  describe "#retake?" do

    it "returns true if the user has already has a grade for the exercise" do
      user = Factory.create :user
      grade_sheet = Factory.create :grade_sheet, :user=>user
      GradeSheet.retake?(user.id, grade_sheet.exercise).should == true 
    end
  end
  
  describe "#complete_set?" do
    
    it "return true if the user has a grade sheet for each exercise in the set" do
      gs1 = Factory.build(:grade_sheet, :user=>@user, :exercise=>@ex1)
      gs2 = Factory.build(:grade_sheet, :user=>@user, :exercise=>@ex2)
      gs1.save
      gs2.save
      gs1.complete_set?.should == true
    end
    
    it "returns false if the @user has not finished the exercise set" do
      gs = Factory.create(:grade_sheet, :grade=>90.0, :user=>@user, :exercise=>@ex1)
      gs.complete_set?.should == false
      
      jim = Factory.create :user
      gs = @ex1.grade_sheets.create!(Factory.build(:grade_sheet, :grade=>90.0, :user=>jim, :exercise=>@ex1).attributes)
      gs.complete_set?.should == false
    end
  end
  
  describe "#grades_in_set" do
    
    it "returns an array containing the user's grade for completed exercises within the set" do
      @ex1.grade_sheets.create!( Factory.build(:grade_sheet, :grade=>90.0, :user=>@user, :exercise=>@ex1).attributes)
      gs = GradeSheet.find :first, :conditions=>{:exercise_id=>@ex1.id}
      gs.grades_in_set.should == [90.0]
      
      @ex2.grade_sheets.create!( Factory.build(:grade_sheet, :grade=>100.0, :user=>@user, :exercise=>@ex2).attributes ) #TODO Using the factory causes this example to crash
      gs = GradeSheet.find :first, :conditions=>{:exercise_id=>@ex1.id}
      gs.grades_in_set.should == [90.0, 100.0]
    end
    
    it "returns the first recorded grade, no retakes" do
      gs = nil
      [90.0, 100.0, 12].each do |g|
         gs = @ex1.grade_sheets.create!( Factory.build(:grade_sheet, :grade=>g, :user=>@user, :exercise=>@ex1).attributes)
      end
      gs.grades_in_set.should == [90.0]
    end
  end
end
