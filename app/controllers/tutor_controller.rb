class TutorController < ApplicationController
  def confirm
    p @params
    @exercise = Exercise.find_by_id(params['id'])
  end
  
  def do_exercise
    
  end
end