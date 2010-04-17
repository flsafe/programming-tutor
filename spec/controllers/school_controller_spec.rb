require 'spec_helper'

describe SchoolController, "GET index" do
  context 'a newly registered user browses their home page' do
    it 'gets exercise sets for the user' do
      current_user = stub_model(User, :username=>'frank', :id=>1000)
      @controller.stub(:current_user).and_return(current_user)
      
      ll_set   = []
      ll_set << stub_model(ExerciseSet, :title=>'Linked List')
      ll_set << stub_model(ExerciseSet, :title=>'Linked List 2')
      
      h_set = []
      h_set << stub_model(ExerciseSet, :title=>'Hash')
      h_set << stub_model(ExerciseSet, :title=>'Hash2')
      
      sets = [ll_set, h_set]

      ExerciseSet.should_receive(:recommend).with(current_user.id, 2).and_return(sets)
      
      get :index
      
      assigns[:exercise_sets].should   == sets
      assigns[:welcome_message].should contain('To start things off')
    end
  end
end