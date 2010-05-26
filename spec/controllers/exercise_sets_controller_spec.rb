require 'spec_helper'

describe ExerciseSetsController do

  before(:each) do
    controller.stub(:current_user).and_return(stub_model(User, 'is_admin?'=>true))
  end
  
  def stub_exercise_set(stubs={})
    @stub_exercise_set ||= stub_model(ExerciseSet, stubs)
  end
  
  it_should_behave_like "controller for admin resource"

  describe "GET index" do
    
    it "assigns all exercise_sets as @exercise_sets" do
      ExerciseSet.stub(:find).and_return([stub_exercise_set])
      get :index
      assigns[:exercise_sets].should == [stub_exercise_set]
    end
  end

  describe "GET show" do
    
    it "assigns the requested exercise_set as @exercise_set" do
      ExerciseSet.stub(:find).and_return(stub_exercise_set)
      get :show
      assigns[:exercise_set].should equal(stub_exercise_set)
    end
  end

  describe "GET new" do
    
    it "assigns a new exercise_set as @exercise_set" do
      stub_exercise_set
      ExerciseSet.stub(:new).and_return(stub_exercise_set)
      get :new
      assigns[:exercise_set].should equal(stub_exercise_set)
    end
  end

  describe "GET edit" do
    
    it "assigns the requested exercise_set as @exercise_set" do
      ExerciseSet.stub(:find).and_return(stub_exercise_set)
      get :edit
      assigns[:exercise_set].should equal(stub_exercise_set)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created exercise_set as @exercise_set" do
        stub_exercise_set(:save => true)
        ExerciseSet.stub(:new).and_return(stub_exercise_set)
        post :create
        assigns[:exercise_set].should equal(stub_exercise_set)
      end

      it "redirects to the created exercise_set" do
        stub_exercise_set(:save=>true)
        ExerciseSet.stub(:new).and_return(stub_exercise_set)
        post :create
        response.should redirect_to(exercise_set_url(stub_exercise_set))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved exercise_set as @exercise_set" do
        stub_exercise_set(:save => false)
        ExerciseSet.stub(:new).and_return(stub_exercise_set)
        post :create
        assigns[:exercise_set].should equal(stub_exercise_set)
      end

      it "re-renders the 'new' template" do
        stub_exercise_set(:save => false)
        ExerciseSet.stub(:new).and_return(stub_exercise_set)
        post :create
        response.should render_template('new')
      end
    end
  end

  describe "PUT update" do
    
    describe "with valid params" do
      it "updates the requested exercise_set" do
        ExerciseSet.should_receive(:find).with("37").and_return(stub_exercise_set)
        stub_exercise_set.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :exercise_set => {:these => 'params'}
      end

      it "assigns the requested exercise_set as @exercise_set" do
        ExerciseSet.stub(:find).and_return(stub_exercise_set(:update_attributes => true))
        put :update, :id => "1"
        assigns[:exercise_set].should equal(stub_exercise_set)
      end

      it "redirects to the exercise_set" do
        ExerciseSet.stub(:find).and_return(stub_exercise_set(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(exercise_set_url(stub_exercise_set))
      end
    end

    describe "with invalid params" do
      it "updates the requested exercise_set" do
        ExerciseSet.should_receive(:find).with("37").and_return(stub_exercise_set)
        stub_exercise_set.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :exercise_set => {:these => 'params'}
      end

      it "assigns the exercise_set as @exercise_set" do
        ExerciseSet.stub(:find).and_return(stub_exercise_set(:update_attributes => false))
        put :update, :id => "1"
        assigns[:exercise_set].should equal(stub_exercise_set)
      end

      it "re-renders the 'edit' template" do
        ExerciseSet.stub(:find).and_return(stub_exercise_set(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    
    it "destroys the requested exercise_set" do
      ExerciseSet.should_receive(:find).with("37").and_return(stub_exercise_set)
      stub_exercise_set.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the exercise_sets list" do
      ExerciseSet.stub(:find).and_return(stub_exercise_set(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(exercise_sets_url)
    end
  end

end
