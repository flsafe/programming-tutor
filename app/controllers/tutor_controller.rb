class TutorController < ApplicationController
  
  before_filter :require_user_or_create_anonymous
  
  before_filter :can_show_exercise?, 
                :start_exercise_session, :only=>:show
                
  before_filter :dispatch_to_observer
                
  after_filter :end_exercise_session, :only=>:grade

  def show
    @exercise = Exercise.find params[:id]
    calc_exercise_end_time
  end
  
  def show_exercise_text
    @exercise = Exercise.find_by_id(params[:id])
  end
  
  def grade
    @exercise = Exercise.find params[:id]
    unless job_running? :grade_solution_job
      enqueue_job :grade_solution_job, GradeSolutionJob.new(params[:code], current_user.id, @exercise.id)
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
  
  def already_doing_exercise
    @current_exercise = current_user.current_exercise
  end
  
  def did_not_finish
    current_user.end_exercise_session
  end
  
  protected
  
  def job_running?(job_name)
    Delayed::Job.find_by_id session[job_name]
  end
  
  def enqueue_job(name, job)
    delayed_job   = Delayed::Job.enqueue job
    session[name] = delayed_job.id
  end
  
  def can_show_exercise?
    current_exercise_session = current_user.exercise_session
    exercise_to_show = Exercise.find params[:id]
    
    can_show = ( not current_exercise_session) || 
      (exercise_to_show.id == current_exercise_session.exercise_id)
      
    unless can_show
      redirect_to :action=>'already_doing_exercise', :id=>current_exercise_session.exercise_id
    end
  end
  
  def start_exercise_session
    @exercise = Exercise.find params[:id]
    current_user.start_exercise_session(@exercise.id) unless current_user.exercise_session_in_progress?
    true
  end
  
  def end_exercise_session
    unless job_running? :grade_solution_job
      current_user.end_exercise_session
    end
  end
  
  def calc_exercise_end_time
    if exercise_session = current_user.exercise_session
      @target_end_time = Time.parse(exercise_session.created_at.to_s) + @exercise.minutes * 60
    end
  end
  
  def dispatch_to_observer
    @user_action_observer ||= UserActionObserver.new
    @user_action_observer.observe(self)
  end
end