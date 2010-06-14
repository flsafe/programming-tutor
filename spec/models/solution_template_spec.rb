require 'spec_helper'

describe SolutionTemplate do
  
  def template
    @template ||= stub_model(SolutionTemplate, :src_code=>"void test_function(){<SRC_CODE>}")
  end
  
  def  file
    @file ||= stub(File, :write=>true)
  end
  
  describe "#fill_in" do
    
    it "fills in the source code template with the provided code" do
      template.fill_in('return 0;');
      template.filled_in_src_code.should == "void test_function(){return 0;}"
    end
  end
end
