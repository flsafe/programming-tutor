require 'spec_helper'

describe "/exercise_sets/edit.html.erb" do
  before(:each) do
    assigns[:exercise_set] = @exercise_set = stub_model(ExerciseSet,
      :new_record? => false
    )
  end

  it "renders the edit exercise_set form" do
    render

    response.should have_tag("form[action=#{exercise_set_path(@exercise_set)}][method=post]") do
    end
  end
end
