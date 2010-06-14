require 'spec_helper'

describe UnitTest do
  
  def unit_test
    @ut ||= Factory.build :unit_test, :src_code=>'<EXEC_NAME>'
  end
  
  def template
    @template ||= mock_model(SolutionTemplate).as_null_object
  end
  
  def curr_time
    "1000"
  end
  
  def exec_name
    "tmp/work/tmp-#{curr_time}-101"
  end
  
  def file
    @stub_file ||= stub(File, :write=>true).as_null_object
  end
  
  before(:each) do
    Kernel.stub(:rand).and_return(100)
    FileUtils.stub(:mkdir_p).and_return(true)
    YAML.stub(:load).and_return({:error=>nil, :grade=>100})
    Time.stub(:now).and_return(stub('time', :usec=>1000))
    unit_test.stub(:execute_file).and_return(true)
    unit_test.stub(:write_unit_test).and_return(true)
  end
  
  describe "#run_on" do
    
    it "compilers the user's solution code to the work directory" do
      solution_code = 'solution code'
      Compiler.stub(:compile_to)
      Compiler.should_receive(:compile_to).with('solution code', "#{APP_CONFIG['work_dir']}/tmp-1000-101")
      unit_test.run_on(template, template.id, solution_code)
    end
    
    it "compiles the user's solution to the temp work dir" do
      #template.should_receive(:compile_to).with(exec_name).once
      #unit_test.run_on(template)
    end
    
    it "sets gives the unit test the name of the executable it will be testing" do
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
    
    context "the solution could not be compiled" do
      it "returns an error result" do
        Compiler.stub(:compile_to).and_return(false)
        result = unit_test.run_on(template)
        result[:error].should_not == nil
      end
    end
  end
end
