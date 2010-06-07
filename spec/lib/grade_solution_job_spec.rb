require 'spec_helper'

describe GradeSolutionJob do
  
  def current_user
    @current_user ||= stub_model(User)
  end
  
  def exercise
    @exercise ||= stub_model(Exercise)
  end
  
  def template
    @template ||= mock_model(SolutionTemplate)
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
  end
end