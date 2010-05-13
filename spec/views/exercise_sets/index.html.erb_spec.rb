require 'spec_helper'

describe "/exercise_sets/index.html.erb" do

  before(:each) do
    assigns[:exercise_sets] = [
      stub_model(ExerciseSet),
      stub_model(ExerciseSet)
    ]
  end
end
