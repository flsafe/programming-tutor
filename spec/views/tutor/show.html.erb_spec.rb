require 'spec_helper'

describe  'tutor/show.html.erb' do
  before(:each) do
    assigns[:exercise] = stub_model(Exercise)
  end
  
  it "displays a text editor" do
    render
    response.should have_selector "#textarea_1"
  end
  
  it "displays the exercise title" do
    assigns[:exercise].stub(:title).and_return("The title")
    render
    response.should contain "The title"
  end
  
  it "displays the exercise problem text" do
    assigns[:exercise].stub(:problem).and_return('exercise text')
    render
    response.should contain "exercise text"
  end
  
  it "displays the exercise hints" do
    assigns[:exercise].stub(:hints).and_return([stub_model Hint, :text=>'hint1'])
    render
    response.should contain "Show Hint 1"
  end
end