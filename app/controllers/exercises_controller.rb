class ExercisesController < ApplicationController
  
  before_filter :require_user, :except=>[:show_tutorial]

  before_filter :require_user_or_create_anonymous, :only=>[:show_tutorial]

  before_filter :redirect_anonymous_if_not_sample_ex, :only=>[:show_tutorial]

  before_filter :redirect_if_not_retake, :only=>[:show_tutorial]

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

  # GET /exercises/new
  # GET /exercises/new.xml
  def new
    @exercise = Exercise.new
    @exercise.hints.build
    @exercise.solution_templates.build
    @exercise.unit_tests.build
    @exercise_sets = ExerciseSet.find(:all, :select=>"id, title")
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @exercise }
    end
  end

  # GET /exercises/1/edit
  def edit
    @exercise = Exercise.find(params[:id])
  end

  # POST /exercises
  # POST /exercises.xml
  def create    
    @exercise = Exercise.new(params[:exercise])
    respond_to do |format|
      if @exercise.save
        flash[:notice] = 'Exercise was successfully created.'
        format.html { redirect_to exercises_path }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /exercises/1
  # PUT /exercises/1.xml
  def update
    params[:exercise][:existing_hint_attributes] ||= {}
    params[:exercise][:existing_unit_test_attributes] ||= {}
    params[:exercise][:existing_solution_template_attributes] ||={}
    
    @exercise = Exercise.find(params[:id])
    respond_to do |format|
      if @exercise.update_attributes(params[:exercise])
        flash[:notice] = 'Exercise was successfully updated.'
        format.html { redirect_to(@exercise) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @exercise.errors, :status => :unprocessable_entity }
      end
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

  def redirect_if_not_retake
    exercise = Exercise.find(params[:id])
    unless current_user.has_role?('admin')
      unless GradeSheet.retake?(current_user.id, exercise.id)
        redirect_to current_user_home
      end
    end
  end
end
