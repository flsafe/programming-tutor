require 'spec_helper'

describe SyntaxChecker do
  
  describe "check_syntax" do
    
    it "returns a message discribing a syntax error if one exists" do
      syntax_checker = SyntaxChecker.new
      code = "int main(){int i = 0 return 0;}"
      msg = syntax_checker.check_syntax(code)
      msg.should =~ /error/
    end
    
    it "returns nil if no syntax error exists" do
      syntax_checker = SyntaxChecker.new
      code = "int main(){ int i = 0; return 0;}"
      msg = syntax_checker.check_syntax code
      msg.should == ""
    end
  end
end
