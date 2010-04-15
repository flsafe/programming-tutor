require 'spec_helper'

describe SchoolController, "GET index" do
  context 'a newly registered user browses their home page' do
    it 'gets exercise sets for the user' do
      current_user = stub_model(User, :username=>'frank', :id=>1000)
      @controller.stub(:current_user).and_return(current_user)
      
      linked_list_set   = []
      linked_list_set << stub_model(ExerciseSet, :title=>'Linked List')
      linked_list_set << stub_model(ExerciseSet, :title=>'Linked List 2')
      
      hash_set = []
      hash_set << stub_model(ExerciseSet, :title=>'Hash')
      hash_set << stub_model(ExerciseSet, :title=>'Hash2')
      
      sets = [linked_list_set, hash_set]
      ExerciseSet.stub(:recommend).and_return(sets)

      ExerciseSet.should_receive(:recommend).with(current_user.id, 2)
      get :index
      assigns[:exercise_sets].should   == sets
      assigns[:welcome_message].should contain('To start things off')
    end
  end
end