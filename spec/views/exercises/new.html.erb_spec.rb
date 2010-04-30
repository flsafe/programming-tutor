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
        :name=>'exercise[tags_attribute][data_structures]'
    end
    
    it "renders a text field for the algorithms tags" do
      render
      response.should have_selector 'input',
        :type=>'text',
        :name=>'exercise[tags_attribute][algorithms]'
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
    
    it "renders a hint text area" do
      assigns[:exercise].stub(:hints).and_return([stub_model(Hint).as_new_record])
      render
      response.should have_selector 'form' do |f|
        f.should have_selector 'textarea',
        :name=>'exercise[hint_attributes][]'
      end
    end
    
    it "renders an add hint link" do
      render
      response.should have_selector 'form' do |f|
          f.should have_selector 'a', :content=>'Add Hint'
      end
    end
    
    it 'renders a remove hint link' do
      assigns[:exercise].stub(:hints).and_return([Factory.create(:hint)])
      render
        response.should have_selector 'form' do |f|
          f.should have_selector '#hints' do |hs|
            hs.should have_selector '.hint' do |h|
              h.should have_selector 'a', :content=>'Remove Hint'
            end
          end
        end
    end
  
    it "renders a select option for the time allowed for this exercise" do
      render
      response.should have_selector 'form' do |f|
        f.should have_selector 'select',
          :name=>'exercise[minutes]'
      end
    end
    
    it "renders a file field to upload a unit test file" do
      assigns[:exercise].stub(:unit_tests).and_return([stub_model(UnitTest).as_new_record])
      render
      response.should have_selector 'form' do |f|
        f.should have_selector 'input', :type=>'file', :name=>'exercise[unit_test_attributes]'
      end
    end
  end
end