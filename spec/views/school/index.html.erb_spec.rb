require 'spec_helper'

class User;end
class ExerciseSet;end
class Exercise;end

describe 'school/index.html.erb' do
  context 'a newly registered user visits their home page' do
    before(:each) do
      assigns[:user]          = mock_model(User, :username=>'Frank')
      assigns[:exercise_sets] = []
    end
    
    it "displays a welcome message" do
      render
      response.should contain('Frank')
    end
    
    it "recomends exercise sets" do
      exercise_sets = []
      exercise_sets << mock_model(ExerciseSet, :title=>'Linked List Basics')
      exercise_sets << mock_model(ExerciseSet, :title=>"Hash Table Basics")
      assigns[:exercise_sets] = exercise_sets
      render
      response.should have_selector('#recommended_exercise_sets') do |recommended|
        recommended.should have_selector(".exercise_set", :content=>'Linked List Basics')
      end
    end
    
  end
end