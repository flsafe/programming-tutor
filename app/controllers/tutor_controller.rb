class TutorController < ApplicationController
  
  before_filter :authorize
  
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
      if does_not_have_job_running
        enqueue_syntax_job
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
    @exercise = Exercise.find_by_id params[:id]
    result    = SyntaxCheckResult.get_result(current_user.id, @exercise.id)
    if result
      @message = result.message
    else
      @message = "checking..."
    end
    respond_to do |f|
      f.js
    end
  end
  
  private
  
  def does_not_have_job_running
    not Delayed::Job.find_by_id session[:syntax_check_job_id]
  end
  
  def enqueue_syntax_job
    syntax_check_job = SyntaxCheckJob.new(params[:code], current_user.id.to_s, params[:id])
    delayed_job      = Delayed::Job.enqueue syntax_check_job
    session[:syntax_check_job_id] = delayed_job.id
  end
end