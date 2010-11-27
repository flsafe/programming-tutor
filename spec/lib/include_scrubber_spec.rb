require 'spec_helper'

describe IncludeScrubber do
 
  def test_input
    test_code =<<-DOC
      #include<time.h>
      #include<sys/resource.h>
      #include<stdlib.h>
      
      int main(){
        return 0;
      }
    DOC
  end

  def expected_output
    out =<<-DOC
      int main(){
        return 0;
      }
    DOC
  end

  before(:each) do
  
  end
  
  describe "scrub_all_includes" do
    
    it "returns a string with no c include directives" do
      clean_str = IncludeScrubber.scrub_all_includes(test_input)
      clean_str.strip.chomp.should == expected_output.strip.chomp
    end
  end
end
