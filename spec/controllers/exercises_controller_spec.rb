require 'spec_helper'

describe ExercisesController do
  def mock_exercise(stubs={})
    @mock_exercise_set ||= mock_model(Exercise, stubs).as_null_object
  end
  
  def mock_c_unit(stubs = {})
    @mock_unit_test ||= mock_model(UnitTest, stubs).as_null_object
  end
  
  describe "post create" do
    
    describe "with valid attributes" do
      it "creates a unit test from the uploaded file" do
        src = 'int main(){return 0;}'
        Exercise.stub(:new).and_return(mock_exercise(:save => true))
        
        mock_c_unit.should_receive(:src_language=).with('c')
        mock_c_unit.should_receive(:src_code=).with(src)
        UnitTest.stub(:new).and_return(mock_c_unit)
        
        file_field = stub("FileField", :original_filename=>'Users/Frank Licea/main.c', :data=>src)
        post(:create, 
          :exercise => {:these => 'params'}, 
          :unit_test=>file_field)
        @mock_exercise_set.unit_test.should == @mock_exercise_set
      end
    end
    
    describe "with 'attach_hint' set" do
      it "attaches another hint field" do
        post :create, :attach_hint=>"anything", :hint_1=>"This is hint 1"
        assigns[:hints].should == ["This is hint 1", ""]
      end
      
      it "rerenders 'new'" do
        Exercise.stub(:new).and_return(mock_exercise(:save => true))
        post :create, :attach_hint=>'anything'
        response.should render_template('new')
      end
    end
    
    describe "with 'attach_image' set" do
      it "attaches another image upload field" do
        post :create, :attach_image=>'anything', :image1=>'/Users/frank licea/main.c'
        assigns[:images].should == ['/Users/frank licea/main.c', ""]
      end
    end
  end
end
