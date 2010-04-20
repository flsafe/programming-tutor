require 'spec_helper'

describe 'school/index.html.erb' do
  before(:each) do
    @current_user = stub_model(User, :username=>'frank')
    @controller.stub(:current_user).and_return(@current_user)
    assigns[:exercise_sets] = []
  end
  
  context 'a newly registered user visits their home page' do
    it "displays a welcome message" do
      render
      response.should contain('frank')
      response.should contain('To start things off')
    end
    
     it "displays a list of recomended exercise sets" do
      exercise_sets = []
      exercise_sets << stub_model(ExerciseSet, :title=>'Linked List')
      exercise_sets << stub_model(ExerciseSet, :title=>'Hash Table')
      assigns[:exercise_sets] = exercise_sets
      
      render
      
      response.should have_selector('#recommended_exercise_sets') do |exercise_sets|
        exercise_sets.should have_selector(".exercise_set", :content=>'Linked List')
        exercise_sets.should have_selector('.exercise_set', :content=>'Hash Table')
      end
    end
   end
    
    it 'marks completed exercise sets' do
      set = stub_model(ExerciseSet)
      @current_user.stub('grade_for?').and_return(true)
      assigns[:exercise_sets] = [set]
      
      render
      
      response.should have_selector('.complete')
    end
    
    it 'displays my grade for completed exercise sets' do
      set = stub_model(ExerciseSet, :title=>"Linked List Basics")
      @current_user.stub('grade_for?').and_return('91.1')
      assigns[:exercise_sets] = [set]
      
      render
      
      response.should contain '91.1'
    end
    
    it 'marks incomplete exercise sets' do
      set = stub_model(ExerciseSet)
      @current_user.stub('grade_for?').and_return(nil)
      assigns[:exercise_sets] = [set]
      
      render
      
      response.should have_selector('.incomplete')
    end
  
  it 'displays the number of users who completed the set and the average grade' do
    exercise_sets = []
    exercise_sets << stub_model(ExerciseSet, :title=>'Linked List', :users_completed=>'100', :average_grade=>'91.55')
    exercise_sets << stub_model(ExerciseSet, :title=>'Hash Table', :users_completed=>'1', :average_grade=>'81.77')
    assigns[:exercise_sets] = exercise_sets
    
    render
    
    verify_stats(response, 'Linked List', '100', '91.55')
    verify_stats(response, 'Hash Table', '1', '81.77')
  end
  
  def verify_stats(response, title, *stat)
    response.should have_selector('.exercise_set', :content=>title) do |exercise|
      stat.each do |s|
        exercise.should contain(s)
      end
    end
  end
  
end