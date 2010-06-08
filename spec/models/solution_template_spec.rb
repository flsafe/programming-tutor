require 'spec_helper'

describe SolutionTemplate do
  
  def template
    @template ||= stub_model(SolutionTemplate, :src_code=>"void test_function(){<SRC_CODE>}")
  end

  describe "#fill_in" do
    
    it "fills in the source code template with the provided code" do
      template.fill_in('return 0;');
      template.filled_in_src_code.should == "void test_function(){return 0;}"
    end
  end
  
  describe "#syntax_error" do
    it "returns a syntax error if one is detected in the filled in source code" do
      template.fill_in('return 0')
      template.syntax_error?.should =~ /error/i
    end
    
    context "the template hasn't been filled in it should return an error" do
      it "does not return a sytnax error" do
        template.syntax_error?.should =~ /error/i
      end
    end
  end
end
