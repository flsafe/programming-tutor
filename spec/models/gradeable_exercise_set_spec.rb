require 'spec_helper'

describe GradeableExerciseSet do
  describe "#track_stats" do
    before(:each) do
      @exercise = Exercise.create! :title=>"@exercise", :description=>'d'
    end
  end
end