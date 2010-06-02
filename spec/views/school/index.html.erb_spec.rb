require 'spec_helper'

describe 'school/index.html.erb' do
  before(:each) do
    @current_user = Factory.stub :user
    @controller.stub(:current_user).and_return(@current_user)
    
    @ex1 = stub_model Exercise
    @ex2 = stub_model Exercise
    
    Exercise.stub(:recommend).and_return([@ex1, @auex2])
    
    assigns[:exercises] = []
  end
  
  context 'a newly registered user visits their home page' do
    it "displays a welcome message" do
      render
      response.should contain(@current_user.username)
      response.should contain('To start things off')
    end
    
     it "displays a list of recomended exercises" do
      assigns[:exercises] = [@ex1, @ex2]
      render
      response.should have_selector('#recommended_exercise_sets') do |exercise_sets|
        exercise_sets.should have_selector(".exercise", :content=>@ex1.title)
        exercise_sets.should have_selector('.exercise', :content=>@ex2.title)
      end
    end
   end
    
    it 'marks completed exercise sets' do
      @current_user.stub('grade_for?').and_return(true)
      assigns[:exercises] = [@ex1]
      render
      response.should have_selector('.exercise.complete')
    end
    
    it 'displays my grade for completed exercise sets' do
      @current_user.stub('grade_for?').and_return('91.1')
      assigns[:exercises] = [@ex1]
      render
      response.should contain '91.1'
    end
    
    it 'marks incomplete exercise sets' do
      @current_user.stub('grade_for?').and_return(nil)
      assigns[:exercises] = [@ex1]
      render
      response.should have_selector('.exercise.incomplete')
    end
  
  it 'displays the number of users who completed the set and the average grade' do
    set1 = stub_model(Exercise, :title=>'Linked List', :completed_users=>[1,2,3], :average_grade=>'91.55')
    set2 = stub_model(Exercise, :title=>'Hash Table', :completed_users=>[1], :average_grade=>'81.77')
    assigns[:exercises] = [set1, set2]
    render
    verify_stats(response, 'Linked List', '3', '91.55')
    verify_stats(response, 'Hash Table', '1', '81.77')
  end
  
  def verify_stats(response, title, *stat)
    response.should have_selector('.exercise', :content=>title) do |exercise|
      stat.each do |s|
        exercise.should contain(s)
      end
    end
  end
  
end