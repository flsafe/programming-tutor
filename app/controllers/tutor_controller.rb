class TutorController < ApplicationController
  
  before_filter :authorize
  
  def show
    if no_current_exercise?
      @exercise = Exercise.find params[:id]
      if @exercise
        set_current_exercise(@exercise.id, Time.now) unless current_user_doing_exercise?
      end
    else
      redirect_to :action=>'already_doing_exercise', :id=>current_exercise_id
    end
  end
  
  def show_exercise_text
    @exercise = Exercise.find_by_id(params[:id])
  end
  
  def grade
    @exercise = Exercise.find params[:id]
    raise "Exercise Not Found" unless @exercise

    unless job_running? :grade_solution_job
      enqueue_job :grade_solution_job, GradeSolutionJob.new(params[:code], current_user.id, @exercise.id)
      clear_current_exercise
    else
      redirect_to :action=>:already_doing_exercise
    end
  end
  
  def grade_status
    @exercise = Exercise.find params[:id]
    raise "Exercise Not Found" unless @exercise
    
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
    raise "Exercise Not Found" unless @exercise

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
    raise "Exercise Not Found" unless @exercise

    @message = SyntaxCheckJob.pop_result(current_user.id, @exercise.id)
    @message = @message || 'checking...'

    respond_to do |f|
      f.html do
        render :text=>@message
      end
    end
  end
  
  def get_time_remaining
    start_time      = current_exercise_start_time
    exercise        = Exercise.find_by_id params[:id], :select=>'minutes'
    @time_remaining = "00:00"
    
    if start_time && exercise
      alloted_time    = exercise.minutes.to_i * 60
      elapsed_time    = Time.now.to_i - start_time.to_i
      
      @time_remaining = [alloted_time - elapsed_time, 0].max
      
      minutes_remain  = @time_remaining / 60
      seconds_remain  = @time_remaining % 60
      @time_remaining = "#{'0' if minutes_remain < 10}#{minutes_remain}:#{'0' if seconds_remain < 10}#{seconds_remain}"
    end
    respond_to do |f|
      f.html {render :text=>@time_remaining}
    end
  end
  
  def already_doing_exercise
    @current_exercise = Exercise.find current_exercise_id
  end
  
  def did_not_finish
    exercise = Exercise.find_by_id(current_exercise_id)
    clear_current_exercise
    
    if exercise
      gs = GradeSheet.new :grade=>0, :user=>current_user, :exercise=>exercise, :unit_test_results=>{}, :src_code=>""
      ta = TeachersAid.new
      ta.record_grade(gs)
    end
  end
  
  protected
  
  def job_running?(job_name)
    Delayed::Job.find_by_id session[job_name]
  end
  
  def enqueue_job(name, job)
    delayed_job   = Delayed::Job.enqueue job
    session[name] = delayed_job.id
  end
  
  def no_current_exercise?
    !(current_user_doing_exercise?) || current_exercise_id.to_i == params[:id].to_i
  end
end