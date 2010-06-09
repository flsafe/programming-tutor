require 'spec_helper'

describe UnitTest do
  
  def unit_test
    @ut ||= stub_model(UnitTest)
  end
  
  def template
    @template ||= mock_model(SolutionTemplate).as_null_object
  end
  
  before(:each) do
    FileUtils.stub(:mkdir_p).and_return(true)
  end
  
  describe "#run_on" do
    
    it "creates a work directory where the compiled solution will be temporarly stored" do
      FileUtils.should_receive(:mkdir_p).with("tmp/work/").once
      unit_test.run_on(template)
    end
    
    it "compiles the user's solution to the temp work dir" do
      template.should_receive(:compile_to)
      unit_test.run_on(template)
    end
  end
end
