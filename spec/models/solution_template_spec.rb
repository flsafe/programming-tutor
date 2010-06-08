require 'spec_helper'

describe SolutionTemplate do
  
  describe "#fill_in" do
    
    it "returns the solution template filled in with the provided code" do
      template = SolutionTemplate.new
      template.src_code = "void test_function(){<SRC_CODE>}"
      code = template.fill_in('return 0;');
      code.should == "void test_function(){return 0;}"
    end
  end
end
