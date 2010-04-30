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
    end
  end
end
