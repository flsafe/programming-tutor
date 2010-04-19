require 'spec_helper'

describe "/exercise_sets/index.html.erb" do
  include ExerciseSetsHelper

  before(:each) do
    assigns[:exercise_sets] = [
      stub_model(ExerciseSet),
      stub_model(ExerciseSet)
    ]
  end

  it "renders a list of exercise_sets" do
    render
  end
end
