require 'spec_helper'

describe SolutionTemplate do
  
  def template
    @template ||= stub_model(SolutionTemplate, :src_code=>"/*start_prototype*/void test_function(){}/*end_prototype*/")
  end
  
  def  file
    @file ||= stub(File, :write=>true)
  end
  
  describe "#fill_in" do
    
    it "fills in the source code template with the provided code" do
      template.fill_in('void test_function(){return 0;}');
      template.filled_in_src_code.should == "void test_function(){return 0;}"
    end
  end
  
  describe "#prototype" do
    
    it "returns the prototype section of the src code" do
      code =<<END
      void test();
      int main(){
        test();
      }
      /*start_prototype*/
      void test(){
        
      }
      /*end_prototype*/
END
      prototype =<<END
      void test(){
        
      }
END
      template.stub(:src_code).and_return(code)
      template.prototype.should =~ /#{Regexp.escape(prototype)}/x
    end
  end
end
