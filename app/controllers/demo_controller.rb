class DemoController < ApplicationController

  def index
    @exercises = get_demo_exercises
  end
  
  protected
  
  def get_demo_exercises
    demo_exercise_titles = APP_CONFIG['demo_exercise_titles']
    @demo_exercises = find_exercise_by_titles(demo_exercise_titles)
  end
  
  def find_exercise_by_titles(demo_exercise_titles)
    exercises = Exercise.find :all, 
      :conditions=>{:title=>demo_exercise_titles}, 
      :select=>'title, id, description'
    exercises
  end
end
