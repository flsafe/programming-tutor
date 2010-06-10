require 'spec_helper'

describe TutorController do
  before(:each) do
    Exercise.stub(:find_by_id).and_return(stub_exercise)
    controller.stub(:current_user).and_return(current_user)
  end
  
  def current_user(stubs={})
    @current_user ||= stub_model(User, stubs)
  end
  
  def grade_sheet(stubs={})
    @grade_sheet ||= stub_model(GradeSheet, stubs)
  end
  
  def grade_solution_result(stubs={})
    @grade_solution_result ||= stub_model(GradeSolutionResult, stubs)
  end
  
  def stub_exercise(stubs={})
    @stub_exercise ||= stub_model(Exercise, stubs)
  end
  
  def code
    "int main(){int i = 0; return 0;}"
  end
  
  describe "get show" do
    
    it "assigns the exercise to be displayed to the user" do
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
      @grade_job = mock_model(GradeSolutionJob, :perform=>true)
      GradeSolutionJob.stub(:new).and_return(@grade_job).as_null_object
      
      @delayed_job = mock_model(Delayed::Job).as_null_object
      Delayed::Job.stub(:new).and_return(@delayed_job)
    end
    
    it "creates a new grade job for the user, with the given code and the current exercise" do
      GradeSolutionJob.should_receive(:new).with(code, current_user.id, stub_exercise.id).once
      post :grade, :code=>code, :id=>stub_exercise.id
    end
    
    it "associates the job with the current session" do
      post :grade, :code=>code, :id=>stub_exercise.id
      session[:grade_solution_job].should == @delayed_job.id
    end
    
    it "assigns a status message" do
      post :grade, :code=>code, :id=>stub_exercise.id
      assigns[:message].should == "grading..."
    end
    
    it "renders grading" do
      post :grade, :code=>code, :id=>stub_exercise.id
      response.should render_template 'tutor/grade'
    end
    
    context "there is already a job associated with the session" do
      it "does not create a new job if the session already has a grade solution job" do
        controller.stub(:job_running?).and_return(true)
        GradeSolutionJob.should_not_receive(:new).with(code, current_user.id, stub_exercise.id)
        post :grade, :code=>code, :id=>stub_exercise.id
      end
    end
    
    context "the given exercise id does not exisit" do
      it "does not create a new job" do
        Exercise.stub(:find_by_id).and_return(nil)
        GradeSolutionJob.should_not_receive(:new).with(code, current_user.id, stub_exercise.id)
        post :grade, :code=>code, :id=>0
      end
    end
  end
  
  describe "get grade_status" do

    context "if the grade solution job was a success" do
      before(:each) do
        GradeSolutionResult.stub(:get_result).and_return(grade_solution_result(:error_message=>nil, :grade_sheet_id=>1000))
        GradeSheet.stub(:find_by_id).and_return(grade_sheet)
      end
      
      it "retrieves the grade solution job result" do
        GradeSolutionResult.should_receive(:get_result).with(current_user.id, stub_exercise.id)
        post :grade_status, :id=>stub_exercise.id
      end
      
      it "retrieves the grade sheet from the db" do
        GradeSheet.should_receive(:find_by_id).with(grade_solution_result.grade_sheet_id)
        post :grade_status, :id=>stub_exercise.id
      end
      
      it "assigns the grade results from the grade sheet" do
        post :grade_status, :id=>stub_exercise.id
        assigns[:grade_sheet].should == grade_sheet
      end
      
      it "renders the grade status rjs" do
        post :grade_status, :id=>stub_exercise.id
        response.should render_template('tutor/grade_status')
      end
    end
    
    context "if the grade solution job was not successfull" do
      before(:each) do
      end
      it "assigns a grade solution error message" do
        pending
      end
      
      it "renders the grade status rjs" do
        pending
      end
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
      session[:syntax_check_job].should == @delayed_job.id
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
    end
    
    context "when the user posts check syntax a few times really fast but they already have a syntax job running" do
      it "doesn't create a new syntax job if the user still has a syntax job in the db" do
        controller.stub(:job_running?).and_return(true)
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
    
    it "assigns sytntax check message" do
      syntax_check_result = stub_model(SyntaxCheckResult, :error_message=>'syntax error', :destroy=>true)
      SyntaxCheckResult.stub(:find).and_return(syntax_check_result)
      get :syntax_status, :id=>stub_exercise
      assigns[:message].should == 'syntax error'
    end
    
    it "renders the syntax message template" do
      get :syntax_status, :id=>stub_exercise.id
      response.should render_template('tutor/syntax_status')
    end
  end
end
