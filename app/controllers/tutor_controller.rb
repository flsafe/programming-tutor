class TutorController < ApplicationController
  
  before_filter :authorize
  
  def confirm
    @exercise = Exercise.find_by_id(params[:id])
  end
  
  def show
    @exercise = Exercise.find_by_id params[:id]
  end
  
  def grade
    @exercise = Exercise.find_by_id params[:id]
    if @exercise
      if not job_running? :grade_solution_job
        enqueue_job :grade_solution_job, GradeSolutionJob.new(params[:code], current_user.id, @exercise.id)
        @message = "grading..."
      else
        @message = "already grading! wait"
      end
    end
    respond_to do |f|
      f.js
    end
  end
  
  def grade_status
    @exercise = Exercise.find_by_id params[:id]
    result    = GradeSolutionResult.get_result(current_user.id, @exercise.id)
    if not result
      @message = 'grading...'
    elsif not result.error_message.blank?
      @message = result.error_message
    else
      @grade_sheet = GradeSheet.find_by_id(result.grade_sheet_id)
    end
    respond_to do |f|
      f.js
    end
  end
  
  def check_syntax
    @exercise = Exercise.find_by_id params[:id]
    if @exercise
      if not job_running? :syntax_check_job
        enqueue_job :syntax_check_job, SyntaxCheckJob.new(params[:code], current_user.id.to_s, params[:id])
      end
      @message = 'checking...'
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
  
  protected
  
  def job_running?(job_name)
    Delayed::Job.find_by_id session[job_name]
  end
  
  def enqueue_job(name, job)
    delayed_job = Delayed::Job.enqueue job
    session[name] = delayed_job.id
  end
end