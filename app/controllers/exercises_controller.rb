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
    @exercise = Exercise.new(extract_exercise(params))
    if modify_form? then
      modify_form
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
  #TODO: Viloation of SRP. Controller currently modifies form, and extracts form data to exercse
  def modify_form
    if attach_hint_field? then
      attach_new_hint_field
    elsif attach_image_field? then
      attach_new_image_field
    end
  end
  
  def attach_new_hint_field
    @hints = vals_for_keys_like(/^hint[1-9]+$/, params)
    @hints << ""
  end
  
  def attach_new_image_field
    @images = vals_for_keys_like(/^image[1-9]+$/, params)
    @images << ""
  end
  
  def extract_exercise(params)
    return {} unless params[:exercise]
    ex_params             = params[:exercise]
    ex_params[:hints]     = extract_hints(params)
    ex_params[:unit_test] = UnitTest.from_file_field(params[:unit_test])
    ex_params
  end
  
   def vals_for_keys_like(like, params)
    field_vals = []
    params.sort.each do |pair|
      key, val = pair[0], pair[1]
      field_vals << val if key =~ like
    end
    field_vals
  end
  
  def extract_hints(params)
    vals_for_keys_like(/^hint[1-9]+$/, params)
  end
  
  def modify_form?
    attach_hint_field? || attach_image_field?
  end
  
  def attach_hint_field?
    params[:attach_hint] and not params[:attach_hint].empty?
  end
  
  def attach_image_field?
    params[:attach_image] and not params[:attach_image].empty?
  end
end
