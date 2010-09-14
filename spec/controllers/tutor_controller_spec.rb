require 'spec_helper'

describe TutorController do
  before(:each) do
    Exercise.stub(:find).and_return(stub_exercise(:minutes=>60))
    controller.stub(:current_user).and_return(current_user)
    controller.session[:current_exercise_id] = stub_exercise.id
  end
  
  def current_user(stubs={})
    @current_user ||= stub_model(User, stubs)
  end
  
  def grade_sheet(stubs={})
    @grade_sheet ||= stub_model(GradeSheet, stubs)
  end
  
  def grade_solution_result(stubs={})
    @grade_solution_result ||= mock("GradeJobResult", stubs).as_null_object
  end
  
  def stub_exercise(stubs={})
    @stub_exercise ||= stub_model(Exercise, stubs)
  end
  
  def code
    "int main(){int i = 0; return 0;}"
  end
  
  describe "get show" do

    context "when the user has no current exercise" do
      it "assigns the exercise to be displayed to the user" do
        get 'show'
        assigns[:exercise].should == stub_exercise
      end
    
      it "sets the current exercise" do
        Time.stub(:now).and_return(Time.parse('7:00'))
        controller.should_receive(:set_current_exercise).with(stub_exercise.id, Time.now)
        get 'show'
      end
    
      it "renders the show template" do
        get 'show'
        response.should render_template('show')
      end
      
      it "does not redirect" do
        controller.stub('current_user_doing_exercise?').and_return(nil)
        get 'show', :id=>stub_exercise
        response.should_not render_template('tutor/already_doing_exercise')
      end
    end
    
    context "the current user is already doing an exercise" do
      before(:each) do
        @curr_exercise = 0
        controller.session[:current_exercise_id] = @curr_exercise
      end
      
      it "does not set the current exercise" do
        controller.should_not_receive(:set_current_exercise)
        get 'show'
      end
      
      it "redirects" do
        get 'show', :id=>1001
        response.should redirect_to(:action=>:already_doing_exercise, :id=>@curr_exercise)
      end
    end
  end
  
  describe "get show_exercise_text" do
    
    it "assigns the exercise to show the problem text for" do
      get 'show_exercise_text', :id=>stub_exercise
      assigns[:exercise].should == stub_exercise
    end
    
    it "renders the exercise text" do
      get 'show_exercise_text'
      response.should render_template 'show_exercise_text'
    end
  end
  
  describe "post grade" do
    
    before(:each) do
      @grade_job = mock_model(GradeSolutionJob, :perform=>true)
      GradeSolutionJob.stub(:new).and_return(@grade_job).as_null_object
      
      @delayed_job = mock_model(Delayed::Job).as_null_object
      Delayed::Job.stub(:new).and_return(@delayed_job)
    end
    
    it "creates a new grade job for the user, with the given code and the current exercise id" do
      start_time      = Time.parse("1:00")
      end_time        = Time.parse("1:30")
      seconds_elapsed = end_time.to_i - start_time.to_i
      
      controller.stub(:current_exercise_start_time).and_return(start_time)
      Time.stub(:now).and_return(end_time)
      
      GradeSolutionJob.should_receive(:new).with(code, current_user.id, stub_exercise.id).once
      post :grade, :code=>code, :id=>stub_exercise.id
    end
    
    it "enqueues the grade job" do
      controller.should_receive(:enqueue_job)
      post :grade, :code=>code, :id=>stub_exercise
    end
    
    it "clears the current exercise" do
      controller.should_receive(:clear_current_exercise)
      post :grade, :code=>code, :id=>stub_exercise
    end
    
    it "associates the job with the current session" do
      post :grade, :code=>code, :id=>stub_exercise.id
      session[:grade_solution_job].should == @delayed_job.id
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
  end
  
  describe "get grade_status" do

    context "if the grade solution job was a success" do
      before(:each) do
        GradeSolutionJob.stub(:pop_result).and_return(grade_solution_result(:error_message=>nil, :in_progress=>nil, :error_message=>nil, :grade_sheet=>grade_sheet))
        GradeSheet.stub(:find).and_return(grade_sheet)
      end
      
      it "retrieves the grade solution job result" do
        GradeSolutionJob.should_receive(:pop_result).with(current_user.id, stub_exercise.id)
        post :grade_status, :id=>stub_exercise.id
      end
      
      it "renders the grade_sheet partial" do
        post :grade_status, :id=>stub_exercise.id
        response.should render_template('grade_sheets/_grade_sheet')
      end
    end
    
    context "there is no grade solution result yet" do
      before(:each) do
        GradeSolutionJob.stub(:pop_result).and_return(grade_solution_result(:in_progress=>true))
      end
      
      it "renders an in-progress message" do
        post :grade_status, :id=>stub_exercise.id
        response.should have_text('Still grading...')
      end
    end
    
    context "if the grade solution job was not successfull" do
      it "renders an error message" do
        GradeSolutionJob.stub(:pop_result).and_return(grade_solution_result(:error_message=>'job error', :in_progress=>nil))
        post :grade_status, :id=>stub_exercise.id
        response.should have_text(/job error/i)
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
      assigns[:message].should == 'checking...'
    end
    
    it 'stores the delayed job id in the session' do
      post :check_syntax, :code=>code, :id=>stub_exercise
      session[:syntax_check_job].should == @delayed_job.id
    end
    
    context "when the user posts check syntax while a syntax check job is running" do
      before(:each) do
        controller.stub(:job_running?).and_return(true)
      end
      
      it "doesn't create a new syntax job if the user still has a syntax job in the db" do
        Delayed::Job.should_not_receive(:enqueue)
        post :check_syntax, :code=>code, :id=>stub_exercise
      end
      
      it "assigns :duplicate_job to the status" do
        post :check_syntax
        assigns[:message].should == 'already checking!'
      end
    end
  end
  
  describe "get syntax_status" do
    
    before(:each) do
      Exercise.stub(:find).and_return stub_exercise
    end
    
    it "retrieves the result of the syntax check" do
      SyntaxCheckJob.should_receive(:pop_result).with(current_user.id, stub_exercise.id)
      get :syntax_status, :id=>stub_exercise.id
    end
    
    it "assigns sytntax check message" do
      syntax_check_result = "Syntax Error"
      SyntaxCheckJob.stub(:pop_result).and_return(syntax_check_result)
      get :syntax_status, :id=>stub_exercise
      assigns[:message].should == "Syntax Error"
    end
    
    context "the syntax message is nil" do
      it "assigns 'checkking...'" do
         syntax_check_result = nil
         SyntaxCheckJob.stub(:pop_result).and_return(syntax_check_result)
         get :syntax_status, :id=>stub_exercise
         assigns[:message].should == "checking..."
      end
    end
  end
  
  describe "get time_remaining" do
    
    before(:each) do
      Time.stub(:now).and_return(Time.parse("7:50"))
      session[:current_exercise_start_time] = Time.parse("7:00")
      @stub_exercise = stub_model(Exercise, :minutes=>'60')
      Exercise.stub(:find).and_return(@stub_exercise)
    end
    
    it "returns the amount of time that is remaining in MM::SS form" do
      get :get_time_remaining, :id=>@stub_exercise
      assigns[:time_remaining].should == "10:00"
    end
    
    it "returns 00:00 if the elapsed time is over the alloted time" do
      Time.stub(:now).and_return(Time.parse("8:30"))
      get :get_time_remaining, :id=>@stub_exercise
      assigns[:time_remaining].should == "00:00"
    end
    
    context "when a start time was not set for the exercise" do
        it "returns 00:00" do
        session[:current_exercise_start_time] = nil
        get :get_time_remaining
        assigns[:time_remaining].should == "00:00"
      end
    end
  end
  
  describe "post did_not_finish" do
    
    it "clears the current exercise" do
      controller.should_receive(:clear_current_exercise)
      post :did_not_finish, :id=>stub_exercise
    end
    
    it "renders did_not_finish" do
      post :did_not_finish
      response.should render_template('tutor/did_not_finish')
    end
  end
end
