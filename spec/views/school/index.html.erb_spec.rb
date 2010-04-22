require 'spec_helper'

describe 'school/index.html.erb' do
  before(:each) do
    @current_user = Factory.stub :user
    @controller.stub(:current_user).and_return(@current_user)
    
    @set1 = Factory.stub :exercise_set
    @set2 = Factory.stub :exercise_set
    
    assigns[:exercise_sets] = []
  end
  
  context 'a newly registered user visits their home page' do
    it "displays a welcome message" do
      render
      response.should contain(@current_user.username)
      response.should contain('To start things off')
    end
    
     it "displays a list of recomended exercise sets" do
      assigns[:exercise_sets] = [@set1, @set2]
      render
      response.should have_selector('#recommended_exercise_sets') do |exercise_sets|
        exercise_sets.should have_selector(".exercise_set", :content=>@set1.title)
        exercise_sets.should have_selector('.exercise_set', :content=>@set2.title)
      end
    end
   end
    
    it 'marks completed exercise sets' do
      @current_user.stub('grade_for?').and_return(true)
      assigns[:exercise_sets] = [@set1]
      render
      response.should have_selector('.exercise_set.complete')
    end
    
    it 'displays my grade for completed exercise sets' do
      @current_user.stub('grade_for?').and_return('91.1')
      assigns[:exercise_sets] = [@set1]
      render
      response.should contain '91.1'
    end
    
    it 'marks incomplete exercise sets' do
      @current_user.stub('grade_for?').and_return(nil)
      assigns[:exercise_sets] = [@set1]
      render
      response.should have_selector('.exercise_set.incomplete')
    end
  
  it 'displays the number of users who completed the set and the average grade' do

    set1 = stub_model(ExerciseSet, :title=>'Linked List', :completed_users=>[1,2,3], :average_grade=>'91.55')
    set2 = stub_model(ExerciseSet, :title=>'Hash Table', :completed_users=>[1], :average_grade=>'81.77')
    assigns[:exercise_sets] = [set1, set2]
    render
    verify_stats(response, 'Linked List', '3', '91.55')
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