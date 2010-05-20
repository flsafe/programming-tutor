require 'spec_helper'

describe TutorController do
  
  describe "get show" do
    
    it "retrieves the exercise to be displayed to the user" do
      exercise = mock_model(Exercise)
      Exercise.stub(:find_by_id).and_return(exercise)
      get 'show'
      assigns[:exercise].should == exercise
    end
    
    it "renders the show template" do
      get 'show'
      response.should render_template('show')
    end
  end
  
  describe "post check_syntax" do
    
    before(:each) do
      @syntax_job = mock_model(SyntaxCheckJob)
      @syntax_job.stub(:perform)
      SyntaxCheckJob.stub(:new).and_return(@syntax_job)
      
      @code = "int main(){int i = 0; return 0;}"
      
      @current_user = Factory.create :user
      @controller.stub(:current_user).and_return(@current_user)
      
      @exercise = Factory.create :exercise
    end
    
     it "gives the code from the text editor to the syntax check job" do
      SyntaxCheckJob.should_receive(:new).with(@code, @current_user.id.to_s, @exercise.id.to_s)
      post :check_syntax, :code=>@code, :id=>@exercise.id
    end
    
    it "starts a new syntax job" do
      Delayed::Job.should_receive(:enqueue).with @syntax_job
      post :check_syntax, :code=>@code
    end
    
    it "renders the check_syntax_status" do
      post :check_syntax
      response.should render_template('tutor/_check_syntax_status')
    end
  end
  
  describe "get syntax_status" do
    
    it "" do
      
    end
  end
end
