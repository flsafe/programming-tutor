require "spec_helper"

describe "exercises/new.html.erb" do
  before(:each) do
    assigns[:exercise] = Factory.build :exercise
  end
  
  describe "new exercise form" do
    
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
  
    it "renders a select option for the time allowed for this exercise" do
      render
      response.should have_selector 'form' do |f|
        f.should have_selector 'select',
          :name=>'exercise[minutes]'
      end
    end
  
    it "renders a input to attach another image" do
      render
      response.should have_selector 'form' do |f|
        f.should have_selector 'input', :name=>'attach_image'
      end
    end
  
    it "renders a file selector to upload a new image" do
      render
      response.should have_selector 'form' do |f|
        f.should have_selector 'input', :type=>'file', :name=>'Upload new image'
      end
    end
  
    it "renders a file selector to upload the unit test for the problem" do
      render
      response.should have_selector 'form' do |f|
        f.should have_selector 'input', :type=>'file', :name=>'exercise[unit_test]'
      end
    end
  end
  
  describe "display hints" do
    it "displays any hints that have been attached" do
      assigns[:hints] = ["hint1", "hint2", "hint3"]
      render
      response.should have_selector 'form' do |f|
        f.should have_selector 'textarea', :content=>'hint1'
        f.should have_selector 'textarea', :content=>'hint2'
        f.should have_selector 'textarea', :content=>'hint3'
      end
    end
  end
  
end