class TutorController < ApplicationController
  def confirm
    @exercise = Exercise.find_by_id(params['id'])
  end
  
  def show
    @exercise = Exercise.find_by_id params[:id]
  end
  
  def grade
    
  end
  
  def check_syntax
    @exercise        = Exercise.find_by_id params[:id]
    syntax_check_job = SyntaxCheckJob.new(params[:code], current_user.id.to_s, params[:id])
    Delayed::Job.enqueue syntax_check_job
    
    respond_to do |f| 
      f.js
    end
  end
  
  def syntax_status
    @exercise           = Exercise.find_by_id params[:id]
    syntax_check_result = SyntaxCheckResult.find :first, :conditions=>['user_id=? AND exercise_id=?', current_user.id, @exercise.id]
    syntax_check_result.delete if syntax_check_result
    if syntax_check_result == nil
      @message = "checking..."
    elsif syntax_check_result.syntax_error?
      @message = syntax_check_result.error_message
    else
      @message = "No syntax errors detected!"
    end
    respond_to do |f|
      f.js
    end
  end
end