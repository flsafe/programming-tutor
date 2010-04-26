require "spec_helper"

describe "exercises/new.html.erb" do
  before(:each) do
    assigns[:exercise] = Factory.build :exercise
  end
  
  it "renders a form to create a new exercise" do
    render
    response.should have_selector('form',
      :method=>'post',
      :action=>exercises_path)
  end
  
  it "renders a text field for the title" do
    render 
    response.should have_selector('form') do |form|
      form.should have_selector('input',
        :type=>'text',
        :name=>'exercise[title]')
    end
  end
  
  it "renders a text field for the description" do
    render
    response.should have_selector 'form' do |f|
      f.should have_selector 'input',
        :type=>'text',
        :name=>'exercise[description]'
    end
  end
  
  it "renders a text field for the tags" do
    render
    response.should have_selector 'input',
      :type=>'text',
      :name=>'tags'
  end
  
  it "renders a text area for the problem text" do
    render
    response.should have_selector 'form' do |f|
      f.should have_selector 'textarea',
        :name=>'exercise[problem]'
    end
  end
  
  it "renders a text area for the tutorial" do
    render
    response.should have_selector 'form' do |f|
      f.should have_selector'textarea',
        :name=>'exercise[tutorial]'
    end
  end
    
end