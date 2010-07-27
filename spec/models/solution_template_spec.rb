require 'spec_helper'

describe SolutionTemplate do
  
  def template
    code = <<-END
    /*start_prototype*/
    void remove_char(char c, char str[]){
  
      /*Your code goes here*/
  
    }
    /*end_prototype*/
    END
    @template ||= stub_model(SolutionTemplate, :src_code=>code)
  end
  
  def  file
    @file ||= stub(File, :write=>true)
  end
  
  describe "#fill_in" do
    
    it "fills in the source code template with the provided code" do
      solution_code = <<-END
        void test_function(){
          return 0;
        }
      END
      template.fill_in(solution_code);
      template.filled_in_src_code.lstrip.rstrip.chomp.should == solution_code.lstrip.rstrip.chomp
    end
    
    it "escapes \\ in the solution code" do
      template.fill_in('this \0 is a test')
      template.filled_in_src_code.lstrip.chomp.should == 'this \\0 is a test'
    end
  end
  
  describe "#prototype" do
    
    it "returns the prototype section of the src code" do
      code = <<-END
      void test();
      int main(){
        test();
      }
      /*start_prototype*/
      void test(){
        
      }
      /*end_prototype*/
      END
      
      prototype = <<-END
      void test(){
        
      }
      END
      template.stub(:src_code).and_return(code)
      template.prototype.should =~ /#{Regexp.escape(prototype)}/x
    end
  end
end
