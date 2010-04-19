require 'spec_helper'

describe "/exercise_sets/show.html.erb" do
  
  before(:each) do
    @ex1 = stub_model(Exercise, :title=>"ex 1", :description=>"ex1 description", :users_completed=>6, :average_grade=>66.1)
    @ex2 = stub_model(Exercise, :title=>"ex 2", :description=>"ex2 description", :users_completed=>10, :average_grade=>77.2)
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
      response.should contain "#{@exercise_set.users_completed}"
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
            stats.should contain("#{exercise.users_completed}")
            stats.should contain("#{exercise.average_grade}")
          end
        end
      end
    end
  end
end
