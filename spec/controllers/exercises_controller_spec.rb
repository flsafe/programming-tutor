require 'spec_helper'

shared_examples_for "controller for admin resource" do
  
  describe "the current user is not an admin" do
    before(:each) do
      current_user = stub_model(User, 'has_role?'=>false, 'is_admin?'=>false)
      controller.stub(:current_user).and_return(current_user)
    end
    
    it "does not allow access to the index" do
      get :index
      response.should redirect_to login_path
    end
    
    it "renders the login page if new is requested" do
      get :new
      response.should redirect_to login_path
    end
    
    it "renders the login page if create is posted" do
      post :create
      response.should redirect_to login_path
    end
    
    it "renders the login page if edit is requested" do
      get :edit
      response.should redirect_to login_path
    end
    
    it "renders the login page if put" do
      put :update
      response.should redirect_to login_path
    end
    
    it "renders the login page if delete" do
      delete  :delete, :id=>'1'
      response.should redirect_to login_path
    end
    
    it "flashes the permssions message"do
      get :new
      flash[:error].should == "You don't have permission to do that!"
    end
  end
end

describe ExercisesController do
  
  it_should_behave_like "controller for admin resource"
  
  before(:each) do
    controller.stub(:current_user).and_return(stub_model(User, 'has_role?'=>true))
  end
  
  def stub_exercise(stubs={})
    unless @stub_exercise
      @stub_exercise = stub_model(Exercise, stubs)
    end
    @stub_exercise
  end
  
  def stub_unit_test(stubs = {})
    @stub_unit_test ||= stub_model(UnitTest, stubs).as_null_object
  end
  
  def stub_exercise_set(stubs = {})
    @stub_exercise_set ||= stub_model(ExerciseSet, stubs).as_null_object
  end
  
  describe 'get new' do
    
    before(:each) do
      stub_exercise
      stub_exercise.stub_chain(:hitns, :build)
      stub_exercise.stub_chain(:figures, :build)
      Exercise.stub(:new).and_return(stub_exercise)
    end
    
    it 'assigns a new hint list containing one new hint' do
      stub_exercise.hints.should_receive(:build).once
      get 'new'
    end
    
    it "assigns a new templates list containg one template" do
      stub_exercise.solution_templates.should_receive(:build).once
      get 'new'
    end
    
    it 'assigns a new unit test list containing one new unit test' do
      stub_exercise.unit_tests.should_receive(:build).once
      get 'new'
    end
    
    it 'assigns a new figure to the exercise' do
      stub_exercise.figures.should_receive(:build).once
      get 'new'
    end
    
    it "assigns a list of existing exercise sets" do
      ExerciseSet.stub(:find).and_return([stub_exercise_set])
      get :new
      assigns[:exercise_sets].should ==([stub_exercise_set])
    end
  end
  
  describe "post create" do
    
    describe "with valid attributes" do
      
      it "creates a new exercise" do
        stub_exercise
        Exercise.stub(:new).and_return(stub_exercise)
        Exercise.should_receive(:new).with({'title'=>'title'})
        post :create, :exercise=>{'title'=>'title'}
      end
      
      it "saves the exercise" do
        stub_exercise
        Exercise.stub(:new).and_return(stub_exercise)
        stub_exercise.should_receive(:save)
        post :create
      end
      
      it 'redirects to the exercise index view' do
        stub_exercise(:save=>true)
        Exercise.stub(:new).and_return(stub_exercise)
        post :create
        response.should redirect_to exercises_path
      end
    end
    
    describe "with invalid attributes" do
      it 'it redirects to the new exercise page' do
        stub_exercise :save=>false
        Exercise.stub(:new).and_return(stub_exercise)
        post :create
        response.should render_template 'new'
      end
    end
  end
end
