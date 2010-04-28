require 'spec_helper'

describe ExercisesController do
  def mock_exercise(stubs={})
    @mock_exercise ||= mock_model(Exercise, stubs).as_null_object
  end
  
  def mock_unit_test(stubs = {})
    @mock_unit_test ||= mock_model(UnitTest, stubs).as_null_object
  end
  
  describe "post create" do
    
    describe "with valid attributes" do
      before(:each) do
        @file_field = stub("FileField", 
          :original_filename=>'Users/Frank Licea/main.c', 
          :data =>'int main(){return 0;}')
        @lang = 'c'
      end
      
      it "creates a unit test from the uploaded file" do
        UnitTest.stub(:new).and_return(mock_unit_test)
        mock_unit_test.should_receive(:src_language=).with(@lang)
        mock_unit_test.should_receive(:src_code=).with(@file_field.data)
        
        post(:create, 
          :exercise=>{},
          :unit_test=>@file_field)
      end
      
      it "creates an exercise with exercise.unit_test extracted from the uploaded file" do
        UnitTest.stub(:new).and_return(mock_unit_test)
        Exercise.should_receive(:new).with({'unit_test'=>mock_unit_test, 'hints'=>[]}).and_return(mock_exercise(:save => true))
        post(:create, :exercise=>{}, :unit_test=>@file_field)
      end
      
      it "saves the new exercise" do
        Exercise.stub(:new).and_return(mock_exercise)
        mock_exercise.should_receive :save
        post(:create, :exercise=>{})
      end
    end
    
    describe "with 'attach_hint' set" do
      it "attaches another hint field" do
        post :create, :attach_hint=>"anything", :hint1=>"This is hint 1"
        assigns[:hints].should == ["This is hint 1", ""]
      end
      
      it "does not save any exercise" do
        Exercise.stub(:new).and_return(mock_exercise)
        mock_exercise.should_not_receive(:save)
        post(:create, :exercise=>{}, :attach_hint=>'anything')
      end
      
      it "rerenders 'new'" do
        post :create, :attach_hint=>'anything'
        response.should render_template('new')
      end
    end
    
    describe "with 'attach_image' set" do
      it "attaches another image upload field" do
        img = '/Users/frank licea/pointer.png'
        post :create, :attach_image=>'anything', :image1=>img
        assigns[:images].should == [img, ""]
      end
      
      it "does not save any exercise" do
        Exercise.stub(:new).and_return(mock_exercise)
        mock_exercise.should_not_receive(:save)
        post(:create, :exercise=>{}, :attach_image=>'anything')
      end
      
      it 're-renders new' do
        post :create, :attach_image=>'anything'
        response.should render_template('new')
      end
    end
  end
end
