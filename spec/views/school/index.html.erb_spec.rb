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
    
    it "recomends exercise sets" do
      exercise_sets = []
      
      p = {'completed?'=>true, :title=>'Linked List Basics', :users_completed=>'90', :average_grade=>'91.01'}
      ll_set = stub_model(ExerciseSet, p)
      exercise_sets << ll_set
      p = {'completed?'=>false, :title=>'Hash Table Basics', :users_completed=>'92', :average_grade=>'93.01'}
      h_set = stub_model(ExerciseSet, p)
      exercise_sets << h_set
      assigns[:exercise_sets] = exercise_sets
      
      render
      
      verify_recommended_exercise_sets(response, true, ll_set.title, ll_set.users_completed, ll_set.average_grade)
      verify_recommended_exercise_sets(response, false, h_set.title, h_set.users_completed, h_set.average_grade)
    end
  end
  
  def verify_recommended_exercise_sets(response, user_completed, exercise_set_content, *statistics)
    response.should have_selector('#recommended_exercise_sets') do |exercise_sets|
      exercise_sets.should have_selector(".exercise_set", :content=>exercise_set_content) do |exercise_set|
        exercise_set.should have_selector(".exercise_set_statistics")
        status = user_completed ? '.complete' : '.incomplete'
        exercise_set.should have_selector(status)
        statistics.each {|statistic| exercise_set.should contain(statistic)}
      end
    end
  end
end