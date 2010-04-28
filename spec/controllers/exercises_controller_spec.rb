require 'spec_helper'

describe ExercisesController do
  def mock_exercise(stubs={})
    @mock_exercise_set ||= mock_model(Exercise, stubs).as_null_object
  end
  
  def mock_c_unit(stubs = {})
    @mock_unit_test ||= mock_model(UnitTest, stubs).as_null_object
  end
  
  describe "post create" do
    
    describe "with valid params" do
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
      end
    end
    
     describe "with 'attach_hint' set" do
      it "attaches another hint" do
        post :create, :attach_hint=>"anything", :hint=>"This is hint 1"
        assigns[:hints].should == ["This is hint 1", ""]
      end
    end
  end
end
