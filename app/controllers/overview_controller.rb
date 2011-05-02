# A user has a 'dinner plate' of exercises
# that must be finished before a new set of exercsises
# is given. The exercises in a plate make up an exercise set.

class OverviewController < ApplicationController
  
  before_filter :require_user
  
  def index
    # Creates a new plate if the user doesn't have one
    current_user.plate_json
    if not current_user.plate.empty?
      @exercise_set = current_user.plate.first.exercise_set
    end
  end

  def current_plate
    @plate_json = current_user.plate_json

    respond_to do |f|
      f.json {render :layout=>false, :json=>@plate_json}
    end
  end

  def show_plate_exercise
    @exercise = Exercise.find_by_id(params[:id],
                                    :select=>'id, title, description')
    respond_to do |f|
      f.html {render :layout=>false, 
             :partial=>'exercises/exercise',
             :locals=>{:exercise=>@exercise}}
    end
  end

  def new_plate
    new_plate_json = current_user.new_plate()
    respond_to do |f|
      f.json {render :json=>new_plate_json}
    end
  end
end
