require 'spec_helper'

describe Recomendation do
  before(:each) do
  end

  describe "for" do
    it "recomends exercises that the user hasn't done" do
      user = Factory.create :user
      completed_exercise = Factory.create :exercise
      new_exercise = Factory.create :exercise

      gs1 = Factory.create :grade_sheet, :user_id=>user.id, :exercise_id=>completed_exercise.id
      user.grade_sheets << gs1

      Recomendation.for(user).should == [new_exercise]
    end

    it "An exercise is not recomended after it is completed" do
      user = Factory.create :user
      completed_exercise = Factory.create :exercise
      new_exercise = Factory.create :exercise

      gs1 = Factory.create :grade_sheet, :user_id=>user.id, :exercise_id=>completed_exercise.id
      user.grade_sheets << gs1

      recomended_exercise = Recomendation.for(user).first
      gs1 = Factory.create :grade_sheet, :user_id=>user.id, :exercise_id=>recomended_exercise.id
      user.grade_sheets << gs1
      Recomendation.for(user).detect {|e| e == recomended_exercise}.should == nil
    end
  end
  
  describe "#recomended?" do
    it "Returns true if the user_id and exercise_id match the current recomendation" do
      usr = Factory.create :user
      ex = Factory.create :exercise
      recomendation = Factory.build :recomendation,
        :user_id=>usr.id,
        :exercise_recomendation_list=>ExerciseRecomendationList.new("#{ex.id}")
      recomendation.save

      Recomendation.recomended?(usr, ex).should == true
    end

    it "returns false if there is no recomendation for the user_id and exercise_id" do
      non_existing_ex_id = 99999
      Factory.create :exercise
      user = Factory.create :user
     
      Recomendation.recomended?(user.id, non_existing_ex_id).should == false
    end
  end


  describe "#random_exercises" do
    it "does not recommend an exercise that is not finished" do
      Factory.create :exercise, :finished=>false
      Factory.create :exercise, :finished=>true
      user = Factory.create :user

      # TODO: For now despite the method name 'random_exercises(s)' it only
      # returns one random exercise.
      10.times do 
        ex = Recomendation.random_exercises(user).first
        ex.finished?.should == true
      end
    end

    it "does not return exercises that the user has already done" do
      user = Factory.create :user
      exercise = Factory.create :exercise
      gs = Factory.build :grade_sheet, :user_id => user.id, :exercise_id => exercise.id, :grade=>100

      user.grade_sheets << gs
      recomended = Recomendation.random_exercises(user)
      recomended.should == [] 
    end 
  end
end
