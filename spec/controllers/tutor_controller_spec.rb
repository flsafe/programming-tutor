require 'spec_helper'

describe TutorController do
  before(:each) do
    controller.stub(:current_user).and_return(current_user)
  end
  
  def current_user(stubs={})
    @current_user ||= stub_model(User, stubs)
  end
  
  def stub_exercise(stubs={})
    @stub_exercise ||= stub_model(Exercise, stubs)
  end
  
  def code
    "int main(){int i = 0; return 0;}"
  end
  
  describe "get show" do
    
    it "assigns the exercise to be displayed to the user" do
      Exercise.stub(:find_by_id).and_return(stub_exercise)
      get 'show'
      assigns[:exercise].should == stub_exercise
    end
    
    it "renders the show template" do
      get 'show'
      response.should render_template('show')
    end
  end
  
  describe "post grade" do
    
    before(:each) do
      Exercise.stub(:find_by_id).and_return(stub_exercise)
      @grade_job = mock_model(GradeSolutionJob, :perform=>true)
    end
    
    it "creates a new grade job for the user, with the given code and the current exercise" do
      GradeSolutionJob.should_receive(:new).with(code, current_user.id, stub_exercise.id).once
      post :grade, :code=>code, :id=>stub_exercise.id
    end
    
    it "does not create a new job for the user if there is a solution_grade_job id in the session and db" do
      Delayed::Job.stub(:find_by_id).and_return(mock_model(GradeSolutionJob, :id=>1000))
      session[:grade_solution_job_id] = 1000
      GradeSolutionJob.should_not_receive(:new).with(code, current_user.id, stub_exercise.id)
      post :grade, :code=>code, :id=>stub_exercise.id
    end
  end
  
  describe "post check_syntax" do
    
    before(:each) do
      @syntax_job  = mock_model(SyntaxCheckJob, :perform=>true)
      SyntaxCheckJob.stub(:new).and_return(@syntax_job)
      
      @delayed_job = stub_model(Delayed::Job)
      Delayed::Job.stub(:enqueue).and_return(@delayed_job)
      
      Exercise.stub(:find).and_return(stub_exercise)
    end
    
     it "creates a new syntax job for the user, with the given code and exercise" do
      SyntaxCheckJob.should_receive(:new).with(code, current_user.id.to_s, stub_exercise.id.to_s)
      post :check_syntax, :code=>code, :id=>stub_exercise.id
    end
    
    it "queues a new syntax job" do
      Delayed::Job.should_receive(:enqueue).with(@syntax_job)
      post :check_syntax, :code=>code, :id=>stub_exercise
    end
    
    it 'assigns a message describing the job is in progress' do
      post :check_syntax, :code=>code, :id=>stub_exercise
      assigns[:message].should == "checking..."
    end
    
    it 'stores the delayed job id in the session' do
      post :check_syntax, :code=>code, :id=>stub_exercise
      session[:syntax_check_job_id].should == @delayed_job.id
    end
    
     it "renders check_syntax" do
      post :check_syntax
      response.should render_template('tutor/check_syntax')
    end
    
    context "when the given exercise id is not in the database" do
      before(:each) do
        Exercise.stub(:find_by_id).and_return(nil)
      end
      
      it "does not start a new job" do
        Delayed::Job.should_not_receive(:enqueue).with @syntax_job
        post :check_syntax
      end
      
      it "assigns an error message" do
        post :check_syntax
        assigns[:message].should == 'Aw shoot! And error occured, try again later.'
      end
    end
    
    context "when the user posts check syntax a few times really fast but they already have a syntax job running" do
      before(:each) do
        Delayed::Job.stub(:find_by_id).and_return(@delayed_job)
        session[:syntax_check_job_id] = @delayed_job.id
      end
      
      it "checks the database for an existing syntax job" do
        Delayed::Job.should_receive(:find_by_id).with(@delayed_job.id)
        post :check_syntax, :code=>code, :id=>stub_exercise
      end
      
      it "doesn't create a new syntax job if the user still has a syntax job in the db" do
        Delayed::Job.should_not_receive(:enqueue)
        post :check_syntax, :code=>code, :id=>stub_exercise
      end
    end
  end
  
  describe "get syntax_status" do
    
    before(:each) do
      Exercise.stub(:find).and_return stub_exercise
    end
    
    it "retrieves the result of the syntax check" do
      SyntaxCheckResult.should_receive(:get_result).with(current_user.id, stub_exercise.id)
      get :syntax_status, :id=>stub_exercise.id
    end
    
    it "renders the syntax message template" do
      get :syntax_status, :id=>stub_exercise.id
      response.should render_template('tutor/syntax_status')
    end
    
    it "assigns sytntax check message" do
      syntax_check_result = stub_model(SyntaxCheckResult, :error_message=>'syntax error', :destroy=>true)
      SyntaxCheckResult.stub(:find).and_return(syntax_check_result)
      get :syntax_status, :id=>stub_exercise
      assigns[:message].should == 'syntax error'
    end
  end
end
