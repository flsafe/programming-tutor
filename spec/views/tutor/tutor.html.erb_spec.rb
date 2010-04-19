require 'spec_helper'

describe  'tutor/confirm.html.erb' do
  it "gives the option to cancel doing the exercise" do
    assigns[:exercise] = exercise = stub_model(Exercise, :title=>"Implement A Singly Linked List")
    render
    response.should have_selector "a", :content=>"Back"
  end
  
  it "gives the option to take the exercise" do
    
  end
end