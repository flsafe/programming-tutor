require 'spec_helper'

describe Recomendation do
  before(:each) do
  end
  
  describe "#recomended?" do
    it "Returns true if the user_id and exercise_id match the current recomendation" do
      usr = Factory.create :user
      ex = Factory.create :exercise
      recomendation = Factory.build :recomendation,
        :user_id=>usr.id,
        :exercise_recomendation_list=>ExerciseRecomendationList.new("#{ex.id}")
      recomendation.save

      Recomendation.recomended?(usr.id, ex.id).should == true
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

      # TODO: For now despite the method name 'random_exercises(s)' it only
      # returns one random exercise.
      10.times do 
        ex = Recomendation.random_exercises.first
        ex.finished?.should == true
      end
    end
  end
end
