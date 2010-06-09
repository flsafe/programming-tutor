require 'spec_helper'

describe UnitTest do
  
  def unit_test
    @ut ||= stub_model(UnitTest, :src_code=>'<EXEC_NAME>')
  end
  
  def template
    @template ||= mock_model(SolutionTemplate).as_null_object
  end
  
  def curr_time
    "1000"
  end
  
  def exec_name
    "tmp/work/tmp-#{curr_time}-#{template.id}"
  end
  
  def file
    @stub_file ||= stub(File, :write=>true).as_null_object
  end
  
  before(:each) do
    FileUtils.stub(:mkdir_p).and_return(true)
    Time.stub(:now).and_return(curr_time)
    unit_test.stub(:execute_file).and_return(true)
    unit_test.stub(:write_unit_test).and_return(true)
  end
  
  describe "#run_on" do
    
    it "creates a work directory where the compiled solution will be temporarly stored" do
      FileUtils.should_receive(:mkdir_p).with("tmp/work").once
      unit_test.run_on(template)
    end
    
    it "compiles the user's solution to the temp work dir" do
      template.should_receive(:compile_to).with(exec_name).once
      unit_test.run_on(template)
    end
    
    it "sets the program the unit test will be testing" do
      unit_test.should_receive(:set_test_program).with(exec_name)
      unit_test.run_on(template)
    end
    
    it "writes the unit test code to a file" do
      unit_test.should_receive(:write_unit_test)
      unit_test.run_on(template)
    end
    
    it "executes the unit test" do
      unit_test.should_receive(:execute_file).with(exec_name+'-unit-test')
      unit_test.run_on(template)
    end
    
    context "the temp dir could not be created" do
      it "returns an error result" do
        pending
      end
    end
    
    context "the solution could not be compiled" do
      it "returns an error result" do
        pending
      end
    end
  end
end
