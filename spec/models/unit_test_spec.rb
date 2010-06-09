require 'spec_helper'

describe UnitTest do
  
  def unit_test
    @ut ||= stub_model(UnitTest, :src_code=>'out = `<EXEC_NAME>`')
  end
  
  def template
    @template ||= mock_model(SolutionTemplate).as_null_object
  end
  
  def curr_time
    "1000"
  end
  
  def exec_name
    "tmp-#{curr_time}-#{template.id}"
  end
  
  before(:each) do
    FileUtils.stub(:mkdir_p).and_return(true)
    Time.stub(:now).and_return(curr_time)
  end
  
  describe "#run_on" do
    
    it "creates a work directory where the compiled solution will be temporarly stored" do
      FileUtils.should_receive(:mkdir_p).with("tmp/work/").once
      unit_test.run_on(template)
    end
    
    it "compiles the user's solution to the temp work dir" do
      template.should_receive(:compile_to).with("tmp/work/#{exec_name}").once
      unit_test.run_on(template)
    end
    
    it "fills in the name of the executable file it will be testing" do
      unit_test.should_receive(:fill_in_executable_to_test).with(exec_name)
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
