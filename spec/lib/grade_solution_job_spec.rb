require 'spec_helper'

describe GradeSolutionJob do
  
  def current_user
    @current_user ||= stub_model(User)
  end
  
  def exercise
    @exercise ||= stub_model(Exercise)
  end
  
  def template
    @template ||= mock_model(SolutionTemplate).as_null_object
  end
  
  def unit_test
    @unit_test ||= mock_model(UnitTest).as_null_object
  end
  
  def job
    @job ||= GradeSolutionJob.new code, current_user.id, exercise.id
  end
  
  def code
    "int main(){return 0;}"
  end
  
  describe "#perform" do
    
    before(:each) do
      template.stub(:syntax_error?).and_return(false)
      SolutionTemplate.stub(:find_by_exercise_id).and_return(template)
      UnitTest.stub(:find_by_exercise_id).and_return(unit_test)
    end
    
    it "creates a new solution template with the user code" do
      template.should_receive(:fill_in).with(code)
      job.perform
    end
    
    it "checks the template for a syntax error" do
      template.should_receive(:syntax_error?)
      job.perform
    end
    
    it "runs the unit test on the template" do
      unit_test.should_receive(:run_on).with(template)
      job.perform
    end
    
    it "creates a new grade sheet from the unit test results" do
      pending
    end
    
    it "records the grade sheet for the user" do
      pending
    end
    
    it "it saves a grade_job_result to the database with a success message" do
      pending
    end
    
    context "the template has a syntax error" do
      it "Saves a grade_job_result with the message describing the syntax error" do
        pending
      end
      
      it "does not record a grade sheet" do
        pending
      end
    end
    
    context "the unit test results indicate that the solution timed out" do
      it "saves a grade_job_result with the message describing the solution timed out" do
        pending
      end

      it "does not save a grade sheet" do
        pending
      end
    end
  end
end