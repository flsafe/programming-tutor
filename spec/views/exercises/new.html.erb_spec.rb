require "spec_helper"

describe "exercises/new.html.erb" do
  before(:each) do
    assigns[:exercise] = stub_model(Exercise)
  end
  
  describe "new exercise form" do
    
    it "renders a form to create a new exercise" do
      render
      response.should have_selector('form',
        :method=>'post')
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
  
    it "renders a text field for the data structure tags" do
      render
      response.should have_selector 'input',
        :type=>'text',
        :name=>'exercise[data_structure_list]'
    end
    
    it "renders a text field for the algorithms tags" do
      render
      response.should have_selector 'input',
        :type=>'text',
        :name=>'exercise[algorithm_list]'
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
        f.should have_selector 'textarea',
          :name=>'exercise[tutorial]'
      end
    end
    
    it "renders an add hint link" do
      render
      response.should have_selector 'form' do |f|
          f.should have_selector 'a', :content=>'Add Hint'
      end
    end
  
    it "renders a select option for the time allowed for this exercise" do
      render
      response.should have_selector 'form' do |f|
        f.should have_selector 'select',
          :name=>'exercise[minutes]'
      end
    end
    
    context "with associated new hints and unit tests" do
      
      before(:each) do
        assigns[:exercise].stub(:unit_tests).and_return([stub_model(UnitTest).as_new_record])
        assigns[:exercise].stub(:hints).and_return([stub_model(Hint).as_new_record])
      end
      
       it "renders a file field to upload a unit test file" do
        render
        response.should have_selector 'form' do |f|
          f.should have_selector 'input', :type=>'file', :name=>'exercise[new_unit_test_attributes][][unit_test_file]'
        end
      end
        
      it 'renders a remove unit test link' do
        render
        response.should have_selector 'a', :content=>'Remove Unit Test'
      end
      
      it "renders a hint text area" do
        render
        response.should have_selector 'form' do |f|
          f.should have_selector 'textarea',
          :name=>'exercise[new_hint_attributes][][text]'
        end
      end
      
      it 'renders a remove hint link' do
        render
        response.should have_selector 'a', :content=>'Remove Hint'
      end
    end
    
    it 'renders a add unit test link' do
      render
      response.should have_selector 'a', :content=>'Add Unit Test'
    end
  end
end