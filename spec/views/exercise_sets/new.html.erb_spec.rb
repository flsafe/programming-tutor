require 'spec_helper'

describe "/exercise_sets/new.html.erb" do

  before(:each) do
    assigns[:exercise_set] = stub_model(ExerciseSet,
      :new_record? => true
    )
  end

  it "renders new exercise_set form" do
    render

    response.should have_tag("form[action=?][method=post]", exercise_sets_path) do
    end
  end
end
