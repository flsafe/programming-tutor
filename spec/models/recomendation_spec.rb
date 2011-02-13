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
      user.save
      
      Recomendation.for(user).should == [new_exercise]
    end

    it "A Recomended exercise is not returned after it is completed" do
      user = Factory.create :user
    
      completed_exercise = Factory.create :exercise
      gs1 = Factory.create :grade_sheet, :user_id=>user.id, :exercise_id=>completed_exercise.id
      user.grade_sheets << gs1
      user.save

      Factory.create :exercise

      recomended_exercise = Recomendation.for(user).first
      gs1 = Factory.create :grade_sheet, :user_id=>user.id, :exercise_id=>recomended_exercise.id
      user.grade_sheets << gs1
      user.save
      Recomendation.for(user).detect {|e| e == recomended_exercise}.should == nil
    end
  end
  
  describe "#recomended?" do
    it "Returns true if the exercise is recomended"  do
      usr = Factory.create :user
      Factory.create :exercise

      exercises = Recomendation.for(usr)
      Recomendation.recomended?(usr, exercises.first).should == true
    end

    it "returns false if there is no recomendation for the user_id and exercise_id" do
      ex = Factory.create :exercise
      user = Factory.create :user
     
      Recomendation.recomended?(user, ex).should == false
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
