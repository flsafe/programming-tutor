require 'spec_helper'

describe 'school/index.html.erb' do
  before(:each) do
    @controller.stub(:current_user).and_return(stub_model(User, :username=>'frank'))
    assigns[:exercise_sets] = []
  end
  
  context 'a newly registered user visits their home page' do
    it "displays a welcome message" do
      render
      response.should contain('frank')
      response.should contain('To start things off')
    end
    
    it "recomends exercise sets" do
      exercise_sets = []
      exercise_sets << stub_model(ExerciseSet, :title=>'Linked List Basics')
      exercise_sets << stub_model(ExerciseSet, :title=>"Hash Table Basics")
      assigns[:exercise_sets] = exercise_sets
      
      render
      
      response.should have_selector('#recommended_exercise_sets') do |recommended|
        recommended.should have_selector(".exercise_set", :content=>'Linked List Basics')
        recommended.should have_selector('.exercise_set'), :content=>'Hash Table Basics'
      end
    end
  end
end