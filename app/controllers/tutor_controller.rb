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
    @exercise = Exercise.find_by_id params[:id]
    if @exercise
      syntax_check_job = SyntaxCheckJob.new(params[:code], current_user.id.to_s, params[:id])
      unless Delayed::Job.find_by_id session[:syntax_check_job_id]
        delayed_job = Delayed::Job.enqueue syntax_check_job
        session[:syntax_check_job_id] = delayed_job.id
      end
      @message = 'checking...'
    else
      @message = 'Aw shoot! And error occured, try again later.'
    end
    
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
    else
      @message = syntax_check_result.result
    end
    respond_to do |f|
      f.js
    end
  end
end