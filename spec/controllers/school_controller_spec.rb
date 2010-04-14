require 'spec_helper'

class User;end
class ExerciseSet;end

describe SchoolController, "GET index" do
  context 'a newly registered user browses their home page' do
    it 'gets exercise sets for the user' do
      new_user          = mock_model(User, :username=>'Frank', :id=>1000)
      session[:current_user] = new_user
      
      linked_list_set   = []
      linked_list_set << mock_model(ExerciseSet, :title=>'Linked List')
      linked_list_set << mock_model(ExerciseSet, :title=>'Linked List 2')
      
      hash_set = []
      hash_set << mock_model(ExerciseSet, :title=>'Hash')
      hash_set << mock_model(ExerciseSet, :title=>'Hash2')
      
      sets = [linked_list_set, hash_set]
      ExerciseSet.stub(:recommend).and_return(sets)

      ExerciseSet.should_receive(:recommend).with(new_user.id)
      get :index
      assigns[:exercise_sets].should   == sets
      assigns[:welcome_message].should contain('To start things off')
    end
  end
end