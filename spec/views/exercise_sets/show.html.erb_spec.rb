require 'spec_helper'

describe "/exercise_sets/show.html.erb" do
  
  before(:each) do
    @current_user = stub_model(User, :username=>'frank', 'grade_for?'=>1000)
    @controller.stub(:current_user).and_return(@current_user)
    
    @ex1 = stub_model(Exercise, :title=>"ex 1", :description=>"ex1 description", :completed_users=>[1,2,3], :average_grade=>66.1)
    @ex2 = stub_model(Exercise, :title=>"ex 2", :description=>"ex2 description", :completed_users=>[1], :average_grade=>77.2)
    assigns[:exercise_set] = @exercise_set = stub_model(ExerciseSet, :title=>'Linked List Basics', :description=>"Implement a linked list", :users_completed=>99, :average_grade=>88, :exercises=>[@ex1, @ex2])
  end

  describe "display" do
    it "displays the exercise set title" do
      render
      response.should contain @exercise_set.title
    end
  
    it "displays the exercise set description" do
      render
      response.should contain @exercise_set.description
    end
  
    it "displays the number of users who completed the exercise set" do
      render
      response.should contain "#{@exercise_set.completed_users.count}"
    end
  
    it "displays the average grade for the exercise set" do
      render
      response.should contain "#{@exercise_set.average_grade}"
    end
  
    it "displays the list of exercises in the exercise set" do
      render
      response.should have_selector "#exercise_list"
    end
    
    it "displays the title of each exercise" do
      render
      response.should have_selector(".exercise_title"), :content=>@ex1.title
      response.should have_selector(".exercise_title"), :content=>@ex2.title
    end
    
    it "displays the desciption of each exercise" do
      render
      response.should have_selector ".exercise_description", :content=>@ex1.description
      response.should have_selector ".exercise_description", :content=>@ex2.description
    end
    
    it "displays the statistics for each exercise" do
      exercises = @exercise_set.exercises
      
      render
      
      exercises.each do |exercise|
        response.should have_selector(".exercise"), :content=>exercise.description do |exercise_elem|
          exercise_elem.should have_selector(".exercise_statistics") do |stats|
            stats.should contain("#{exercise.completed_users.count}")
            stats.should contain("#{exercise.average_grade}")
          end
        end
      end
    end
    
   it "displays the current users grade for each exercise and a completed indicator" do
     @current_user.stub(:grade_for?).and_return 91.1
     
     render
     
     response.should have_selector '.exercise.complete', :content=>@ex1.title do |exercise|
       exercise.should contain "91.1"
     end
   end
   
   it "does not display a grade or a completed indicator if the user has does not have a grade" do
     @current_user.stub(:grade_for?).and_return nil
     
     render
     
     response.should have_selector '.exercise.incomplete', :content=>@ex1.title
   end
  end
end
