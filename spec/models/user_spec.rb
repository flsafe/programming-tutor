require 'spec_helper'

describe User do
  
  before(:each) do
      @current_user = Factory.create :user

      @exercise_set = Factory.create :exercise_set
      @exercise_set.exercises.push(Factory.build :exercise, :exercise_set_id=>@exercise_set)
      @exercise_set.exercises.push(Factory.build :exercise, :exercise_set_id=>@exercise_set)
      
      @exercise = @exercise_set.exercises[0]
  end

  describe  "#grade_for" do
    
    it "returns the grade for the associated exercise" do
      @exercise.grade_sheets.create!(Factory.build(:grade_sheet, :grade=>92.1, :user=>@current_user, :exercise=>@exercise).attributes)
      @current_user.grade_for(@exercise).should == 92.1
    end
  
    it "returns the most recent grade" do
     Factory.create :grade_sheet, :grade=>60, :user=>@current_user, :exercise=>@exercise
     Factory.create :grade_sheet, :grade=>90, :user=>@current_user, :exercise=>@exercise
     sleep(1) #Make sure one is inserted at a later time
     Factory.create(:grade_sheet, :grade=>100, :user=>@current_user, :exercise=>@exercise)
     @current_user.grade_for(@exercise).should == 100
    end
  
    it "returns nil if there is no grade sheet associated with the exercise" do
      @current_user.grade_for(@exercise).should == nil
    end
  end

  describe "#plate_json" do

    it "returns the plate exercises in json form including: ex_id, grade, order" do
      @ex1, @ex2 = @exercise_set.exercises[0], @exercise_set.exercises[1]
      @current_user.plate.push(@ex1, @ex2)
      add_grade_sheets

      expected_plate = {:plate => [{:ex_id => @ex1.id, :grade => 90.0, :order => @ex1.order},
                               {:ex_id => @ex2.id, :grade => 90.0, :order => @ex2.order}]}
      @current_user.plate_json.should == expected_plate 
    end

    def add_grade_sheets
      @current_user.grade_sheets.push(Factory.build(:grade_sheet, 
                                                       :user_id=>@current_user.id, 
                                                       :exercise_id=>@ex1.id, 
                                                       :grade=>90.0))
      @current_user.grade_sheets.push(Factory.build(:grade_sheet, 
                                                       :user_id=>@current_user.id, 
                                                       :exercise_id=>@ex2.id,
                                                       :grade=>90.0))
    end

    context "The user has nothing on their plate" do
      it "creates a new plate using the exercises from a random exercise set" do
        @ex1, @ex2 = @exercise_set.exercises[0], @exercise_set.exercises[1]

        plate_json = {:plate => [{:ex_id => @ex1.id, :grade => nil, :order => @ex1.order},
                                 {:ex_id => @ex2.id, :grade => nil, :order => @ex2.order}]}
        @current_user.plate_json.should == plate_json
      end
    end
  end

  describe "#new_plate" do
    it "creates a new plate for the user" do
        @current_user.plate = @exercise_set.exercises
        plate_json = @current_user.plate_json
        
        new_plate = @current_user.new_plate

       new_plate.should_not == nil and new_plate.should_not == plate_json 
    end

    context "the plate has not been finished (all grades are 100)" do
      it "does not change the users plate" do
        @current_user.plate = @exercise_set.exercises
        lambda {@current_user.new_plate}.should_not change(@current_user, :plate)
      end
    end
  end
end
