require 'spec_helper'

describe TutorController do
  before(:each) do
    @current_user = Factory.create :user
    @controller.stub(:current_user).and_return(@current_user)
      
    @exercise = Factory.create :exercise
  end
  
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
      response.should render_template('tutor/check_syntax')
    end
  end
  
  describe "get syntax_status" do
    
    it "retrieves the result of the syntax check" do
      SyntaxCheckResult.should_receive(:find).with(:first, :conditions=>['user_id=? AND exercise_id=?', @current_user.id, @exercise.id])
      get :syntax_status, :id=>@exercise.id
    end
    
    it "clears the syntax check result" do
      
    end
    
    it "renders the syntax message template" do
      get :syntax_status, :id=>@exercise.id
      response.should render_template('tutor/syntax_status')
    end
    
    it "returns the sytntax error message" do
      syntax_check_result = stub_model(SyntaxCheckResult, :error_message=>'syntax error')
      SyntaxCheckResult.stub(:find).and_return(syntax_check_result)
    
      get :syntax_status, :id=>@exercise
      assigns[:message].should == 'syntax error'
    end
  end
end
