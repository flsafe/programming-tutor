require 'spec_helper'

describe  'tutor/confirm.html.erb' do
  it "gives the option to cancel doing the exercise" do
    assigns[:exercise] = stub_model Exercise
    render
    response.should have_selector "a", :content=>"Back"
  end
end