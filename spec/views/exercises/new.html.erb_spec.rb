require "spec_helper"

describe "exercises/new.html.erb" do
  it "renders a form to create a new exercise" do
    render
    response.should have_selector('form',
      :method=>'post',
      :action=>new_exercise_path)
  end
end