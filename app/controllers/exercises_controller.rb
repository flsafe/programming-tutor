class ExercisesController < ApplicationController
  # GET /exercises
  # GET /exercises.xml
  def index
    @exercises = Exercise.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @exercises }
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

  # GET /exercises/new
  # GET /exercises/new.xml
  def new
    @exercise = Exercise.new

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
    @exercise = Exercise.new(unpack_exercise)
    if attach_hint_field? then
      attach_new_hint_field
      respond_to do |format|
        format.html { render :action => "new" }
        format.xml  { render :xml => @exercise.errors, :status => :unprocessable_entity }
      end
    else
      respond_to do |format|
        if @exercise.save
          flash[:notice] = 'Exercise was successfully created.'
          format.html { redirect_to(@exercise) }
          format.xml  { render :xml => @exercise, :status => :created, :location => @exercise }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @exercise.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /exercises/1
  # PUT /exercises/1.xml
  def update
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
  
  private
  
  def unpack_exercise
    return unless params[:exercise]
    ex_params             = params[:exercise]
    ex_params[:hints]     = unpack_hints
    ex_params[:unit_test] = unpack_unit_test
    ex_params
  end
  
  def unpack_hints
    hints = []
    params.sort.each do |pair|
      key, hint = pair[0], pair[1]
      hints << hint if hint_field?(key)
    end
    hints
  end
  
  def unpack_unit_test
    UnitTest.from_file_field(params[:unit_test])
  end
  
  def hint_field?(str)
     str.include? 'hint' and not str.include? 'attach'
  end
  
  def attach_hint_field?
    params[:attach_hint] and not params[:attach_hint].empty?
  end
  
  def attach_new_hint_field
    @hints = unpack_hints
    @hints << ""
  end
end
