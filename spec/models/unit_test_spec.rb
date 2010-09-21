require 'spec_helper'

describe UnitTest do
  
  def unit_test
    @ut ||= Factory.build :unit_test, :src_code=>'ruby ./<EXEC_NAME>'
  end
  
  def file
    @stub_file ||= stub(File, :write=>true).as_null_object
  end
  
  def work_dir
    APP_CONFIG['work_dir']
  end
  
  before(:each) do
    @user_program_path = "#{work_dir}/executable_solution"
    
    CozyFileUtils.stub(:unique_file_in).and_return(@user_program_path)
    Compiler.stub(:compile_to).and_return(true)
    unit_test.stub(:execute_unit_test_file).and_return("---\n:error: nil\ngrade: 100")

    unit_test.stub(:write_unit_test_to_file).and_return(true)
  end
  
  describe "#run_on" do
    
    it "compiles the user's program to the work directory" do
      solution_code = 'int main(){return 0;}'
      Compiler.stub(:compile_to)
      Compiler.should_receive(:compile_to).with(solution_code, @user_program_path)
      unit_test.run_on(solution_code)
    end
      
    it "replaces <EXEC_NAME> in the unit test src with the the user's program executable" do
      mock_code = mock(String)
      unit_test.stub(:src_code).and_return(mock_code)
      mock_code.should_receive(:gsub).with(/<EXEC_NAME>/, @user_program_path)
      unit_test.run_on('code')
    end
    
    it "writes the unit test code to a file" do
      unit_test.should_receive(:write_unit_test_to_file)
      unit_test.run_on('code')
    end
    
    it "executes the unit test" do
      unit_test.should_receive(:execute_unit_test_file)
      unit_test.run_on('code')
    end
    
    context "the solution could not be compiled" do
      it "returns the error message describing the solution did not compile" do
        Compiler.stub(:compile_to).and_return(false)
        result = unit_test.run_on('code')
        result[:error].should =~ /did not compile/i
      end
    end
    
    context "the unit test returns an invalid YML result string" do
      it "returns the error message :no_result_returned" do
        ['shit#%$#$%crap', nil, false, ""].each do |t|
          unit_test.stub(:execute_file).and_return(t)
          result = unit_test.run_on('code')
          result[:error].should =~ /did not return/i
        end
      end
    end
    
    context "an exception is raised while attempting to run the unit test" do
      it "returns the error message :no_result_returned" do
        unit_test.should_receive(:write_unit_test_to_file).and_raise("A Mock Exception")
        result = unit_test.run_on('code')
        result[:error].should =~ /exception/i
      end
    end
  end
end
