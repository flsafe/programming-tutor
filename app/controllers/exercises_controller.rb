class ExercisesController < ApplicationController
  
  before_filter :require_user, :except=>[:show_tutorial]

  before_filter :require_user_or_create_anonymous, :only=>[:show_tutorial]

  before_filter :redirect_anonymous_if_not_sample_ex, :only=>[:show_tutorial]

  before_filter :redirect_regular_user_if_no_grade, :only=>[:show_tutorial]

  before_filter :require_admin, :except=>[:user_index, :show, :show_tutorial]
  
  # GET /exercises
  # GET /exercises.xml
  def index
    @exercises = Exercise.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @exercises }
    end
  end
  
  def user_index
    @exercises = current_user.completed_exercises
    
    respond_to do |format|
      format.html #index.html.erb
      format.xml {render :xml=>@exercises}
    end
  end

  # GET /exercises/1
  # GET /exercises/1.xml
  def show
    @exercise = Exercise.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @exercise }
    end
  end
  
  def show_tutorial
    @exercise      = Exercise.find(params[:id])
    @tutorial_html = @exercise.tutorial
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @exercise }
    end
  end

  # DELETE /exercises/1
  # DELETE /exercises/1.xml
  def destroy
    @exercise = Exercise.find(params[:id])
    @exercise.destroy

    respond_to do |format|
      format.html { redirect_to(exercises_url) }
      format.xml  { head :ok }
    end
  end

  protected

  def redirect_anonymous_if_not_sample_ex 
    if current_user.anonymous?
      @exercise = Exercise.find params[:id]
      unless @exercise.sample?
        redirect_to :controller=>:landing
      end
    end
  end

  def redirect_regular_user_if_no_grade
    exercise = Exercise.find(params[:id])
    unless current_user.anonymous? or current_user.is_admin?
      unless current_user.grade_for(exercise)
        redirect_to current_user_home
      end
    end
  end
end
