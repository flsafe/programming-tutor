class TutorController < ApplicationController
  
  before_filter :authorize
  
  def show
    if no_current_exercise_or_show_current_exercise?
      @exercise = Exercise.find_by_id params[:id]
      if @exercise
        set_current_exercise(@exercise.id, Time.now) unless current_user_doing_exercise?
      end
    else
      redirect_to :action=>'already_doing_exercise', :id=>current_exercise_id
    end
  end
  
  def grade
    @exercise = Exercise.find_by_id params[:id]
    if @exercise
      if not job_running? :grade_solution_job
        enqueue_job :grade_solution_job, GradeSolutionJob.new(params[:code], current_user.id, @exercise.id)
        @status = :job_enqueued
        clear_current_exercise
      else
        @status = :duplicate_job
      end
    else
      @status = :exercise_dne
    end
    respond_to do |f|
      f.html
    end
  end
  
  def grade_status
    @exercise = Exercise.find_by_id params[:id]
    raise "Exercise not found" unless @exercise

    @result   = GradeSolutionResult.get_result(current_user.id, @exercise.id)
    if not @result
      @status = :job_in_progress
    elsif not @result.error_message.blank?
      @status  = :job_error
    else
      @grade_sheet = GradeSheet.find_by_id(@result.grade_sheet_id)
      @status = :job_done
    end
    
    respond_to do |f|
      f.html do 
        if @status == :job_in_progress
          render :text=>'grading...'
        elsif @status == :job_error
          render :text=> "Oops! Error: #{@result.error_message}"
        elsif @status == :job_done
          render :partial=>'grade_sheet', :layout=>false
        else
          render :text=>"Oh no! This wasn't supposed to happen! We encountered an error, try again a bit later."
        end
      end
    end
  end
  
  def check_syntax
    @exercise = Exercise.find_by_id params[:id]
    if @exercise
      if not job_running? :syntax_check_job
        enqueue_job :syntax_check_job, SyntaxCheckJob.new(params[:code], current_user.id.to_s, params[:id])
        @status = :job_enqueued
      else
        @status = :duplicate_job
      end
    else
      @status = :exercise_dne
    end    
    
    respond_to do |f| 
      f.html do
         message = case @status
          when :job_enqueued  then "checking..."
          when :duplicate_job then "already checking!"
          when :exercise_dne  then "an error occured!"
        end
        render :text=>message
      end
    end
  end
  
  def syntax_status
    @exercise = Exercise.find_by_id params[:id]
    if @exercise
      @result = SyntaxCheckResult.get_result(current_user.id, @exercise.id)
      if @result
        @status  = :job_done
      else
        @status = :job_in_progress
      end
    else
      @status = :exercise_dne
    end
    
    respond_to do |f|
      f.html do
        message = case @status
          when :job_done        then @result.message
          when :job_in_progress then "checking..."
          when :exercise_dne    then "an error occured"
        end
        render :text=>message
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
    
  end
  
  def did_not_finish
    exercise = Exercise.find_by_id(current_exercise_id)
    clear_current_exercise
    
    if exercise
      gs = GradeSheet.new :grade=>0, :user=>current_user, :exercise=>exercise, :unit_test_results=>"dnf", :src_code=>"dnf"
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
  
  def no_current_exercise_or_show_current_exercise?
    !(current_user_doing_exercise?) || current_exercise_id.to_i == params[:id].to_i
  end
end