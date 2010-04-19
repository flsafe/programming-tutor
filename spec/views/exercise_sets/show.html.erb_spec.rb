require 'spec_helper'

describe "/exercise_sets/show.html.erb" do
  include ExerciseSetsHelper
  before(:each) do
    assigns[:exercise_set] = @exercise_set = stub_model(ExerciseSet)
  end

  it "renders attributes in <p>" do
    render
  end
end
