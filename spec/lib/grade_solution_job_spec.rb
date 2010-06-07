require 'spec_helper'

describe GradeSolutionJob do
  
  def current_user
    @current_user ||= stub_model(User)
  end
  
  def exercise
    @exercise ||= stub_model(Exercise)
  end
  
  def template
    @template ||= stub(SolutionTemplate)
  end
  
  def code
    "int main(){return 0;}"
  end
  
  describe "#perform" do
    
    before(:each) do
      SolutionTemplate.stub(:new).and_return(template)
    end
    
    it "creates a new solution template with the user code" do
      template.should_receive(:fill_in).with(code)
      GradeSolutionJob.new code, current_user.id, exercise.id
    end
    
    it "checks the template for a syntax error" do
      pending
    end
    
    it "runs the unit test on the template" do
      pending
    end
    
    it "creates a grade sheet from the unit test results" do
      pending
    end
    
    it "it saves a grade_job_result to the database with a success message" do
      pending
    end
    
    context "the template has a syntax error" do
      it "Saves a grade_job_result with the message describing the syntax error" do
        pending
      end
    end
  end
end