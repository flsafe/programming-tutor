require 'spec_helper'

describe ExerciseSet do

  describe "valid exercise set" do
    before(:each) do
      @valid_attributes = {
        :title=>'LinkedList', :description=>'Implement'
      }
      @exercise_set = ExerciseSet.create! @valid_attributes
    end

    
    it 'is valid with valid attributes' do
      @exercise_set.should be_valid
    end
    
    it "is not valid without a title" do
      @exercise_set.title = nil
      @exercise_set.should_not be_valid
    end
    
    it "is not valid without a description" do
      @exercise_set.description = nil
      @exercise_set.should_not be_valid
    end
  end

  describe "random_incomplete_set_for" do

    it "returns an exercise set that the user has not completed" do
      @user = Factory.create :user
      create_exercise_sets
      create_grade_sheets_for_complete_exercise_set

      ExerciseSet.random_incomplete_set_for(@user).should == @incomplete
    end

    def create_exercise_sets
      @incomplete = Factory.create :exercise_set
      @incomplete.exercises.push(Factory.build(:exercise, :exercise_set_id=>@incomplete))
      @incomplete.exercises.push(Factory.build(:exercise, :exercise_set_id=>@incomplete))

      @complete = Factory.create :exercise_set
      @complete.exercises.push(Factory.build(:exercise, :exercise_set_id=>@complete))
      @complete.exercises.push(Factory.build(:exercise, :exercise_set_id=>@complete))

    end

    def create_grade_sheets_for_complete_exercise_set
      @user.grade_sheets.push(Factory.build(:grade_sheet, 
                                            :user_id=>@user.id, 
                                            :grade=>100.0, 
                                            :exercise_id=>@complete.exercises[0].id))

      @user.grade_sheets.push(Factory.build(:grade_sheet, 
                                            :user_id=>@user.id, 
                                            :grade=>100.0, 
                                            :exercise_id=>@complete.exercises[1].id))
    end
  end
end
