require 'spec_helper'

describe ExercisesController do
  
  before(:each) do
    controller.stub(:current_user).and_return(stub_model(User, 'has_role?'=>true))
  end
  
  def mock_exercise(stubs={})
    @mock_exercise ||= mock_model(Exercise, stubs).as_null_object
  end
  
  def mock_unit_test(stubs = {})
    @mock_unit_test ||= mock_model(UnitTest, stubs).as_null_object
  end
  
  def mock_exercise_set(stubs = {})
    @mock_exercise_set ||= mock_model(ExerciseSet, stubs).as_null_object
  end
  
  describe 'get new' do
    
    before(:each) do
        Exercise.stub(:new).and_return(mock_exercise)
    end
    
    it 'assigns a new hint list containing one new hint' do
      mock_exercise.stub_chain(:hints, :build)
      mock_exercise.hints.should_receive(:build).once
      get 'new'
    end
    
    it 'assigns a new unit test list containing one new unit test' do
      mock_exercise.stub_chain(:unit_tests, :build)
      mock_exercise.unit_tests.should_receive(:build).once
      get 'new'
    end
    
    it 'assigns a new figure to the exercise' do
      mock_exercise.stub_chain(:figures, :build)
      mock_exercise.figures.should_receive(:build).once
      get 'new'
    end
    
    it "assigns a list of existing exercise sets" do
      ExerciseSet.stub(:find).and_return([mock_exercise_set])
      get :new
      assigns[:exercise_sets].should ==([mock_exercise_set])
    end
    
    describe "the current user is not an admin" do
      before(:each) do
        current_user = stub_model(User, 'has_role?'=>false)
        controller.stub(:current_user).and_return(current_user)
      end
      
      it "renders the login page" do
        get :new
        response.should redirect_to login_path
      end
      
      it "flashes the permssions message"do
        get :new
        flash[:error].should == "You don't have permission to do that!"
      end
    end
  end
  
  describe "post create" do
    
    describe "with valid attributes" do
      
      it "creates a new exercise" do
        Exercise.should_receive(:new).with({'title'=>'title'}).and_return(mock_exercise)
        post :create, :exercise=>{'title'=>'title'}
      end
      
      it "saves the exercise" do
        Exercise.should_receive(:new).and_return(mock_exercise)
        mock_exercise.should_receive(:save)
        post :create
      end
      
      it 'redirects to the exercise index view' do
        Exercise.stub(:new).and_return(mock_exercise :save=>true)
        post :create
        response.should redirect_to exercises_path
      end
    end
    
    describe "with invalid attributes" do
      it 'it redirects to the new exercise page' do
        Exercise.stub(:new).and_return(mock_exercise :save=>false)
        post :create
        response.should render_template 'new'
      end
    end
  end
end
