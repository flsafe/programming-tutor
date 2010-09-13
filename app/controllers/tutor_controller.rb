class TutorController < ApplicationController
  
  before_filter :authorize, :dispatch_to_observer
  
  def show
    @exercise = Exercise.find params[:id]
    
    if can_show_exercise?(@exercise)
        set_current_exercise(@exercise.id, Time.now)
    else
      redirect_to :action=>'already_doing_exercise', :id=>current_exercise_id
    end
  end
  
  def show_exercise_text
    @exercise = Exercise.find_by_id(params[:id])
  end
  
  def grade
    @exercise = Exercise.find params[:id]

    unless job_running? :grade_solution_job
      elapsed_seconds = Time.now.to_i - current_exercise_start_time.to_i
      enqueue_job :grade_solution_job, GradeSolutionJob.new(params[:code], current_user.id, @exercise.id)
      clear_current_exercise
    end
  end
  
  def grade_status
    @exercise = Exercise.find params[:id]
    
    result    = GradeSolutionJob.pop_result(current_user.id, @exercise.id)
      
    respond_to do |f|
      f.html do 
        if result.in_progress
          render :text=>'Still grading...'
        elsif result.error_message
          render :text=> "Oops! Error: #{result.error_message}"
        elsif result.grade_sheet
          render :partial=>'grade_sheets/grade_sheet', :layout=>false, :object=>result.grade_sheet
        else
          render :text=>"Oh no! This wasn't supposed to happen! We encountered an error, try again a bit later."
        end
      end
    end
  end
  
  def check_syntax
    @exercise = Exercise.find params[:id]

    unless job_running? :syntax_check_job
      enqueue_job :syntax_check_job, SyntaxCheckJob.new(params[:code], current_user.id.to_s, @exercise.id.to_s)
      @message = 'checking...'
    else
      @message = 'already checking!'
    end
    
    respond_to do |f| 
      f.html do
        render :text=>@message
      end
    end
  end
  
  def syntax_status
    @exercise = Exercise.find params[:id]

    @message = SyntaxCheckJob.pop_result(current_user.id, @exercise.id)
    @message = @message || 'checking...'

    respond_to do |f|
      f.html do
        render :text=>@message
      end
    end
  end
  
  def get_time_remaining
    start_time       = current_exercise_start_time
    exercise         = Exercise.find params[:id], :select=>'minutes'
    @time_remaining  = CozyTimeUtils.time_remaining(start_time, exercise.minutes)
    
    respond_to do |f|
      f.html {render :text=> @time_remaining}
    end
  end
  
  def already_doing_exercise
    @current_exercise = Exercise.find current_exercise_id
  end
  
  def did_not_finish
    clear_current_exercise
  end
  
  protected
  
  def job_running?(job_name)
    Delayed::Job.find_by_id session[job_name]
  end
  
  def enqueue_job(name, job)
    delayed_job   = Delayed::Job.enqueue job
    session[name] = delayed_job.id
  end
  
  def can_show_exercise?(exercise)
    ( not current_user_doing_exercise?)         || 
    ( exercise.id == current_exercise_id.to_i )
  end
  
  def dispatch_to_observer
    @user_action_observer ||= UserActionObserver.new
    @user_action_observer.observe(self)
  end
end