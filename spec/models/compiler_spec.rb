require 'spec_helper'

describe Compiler do
  
  describe "#syntax_error?" do
    it "returns false if no syntax error is detected" do
      src = "int main(){return 0;}"
      Compiler.syntax_error?(src).should == false
    end
    
    it "return true if a syntax error is detected" do
      src = "int main(){int i = 0 return 0;}"
      Compiler.syntax_error?(src).should == true
    end
  end
  
  describe "#compile_to" do
    
  end
end
