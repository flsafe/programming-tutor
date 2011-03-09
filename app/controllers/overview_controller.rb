class OverviewController < ApplicationController
  
  before_filter :require_user
  
  def index
  end

  def current_plate
    @plate_json = current_user.plate_json

    respond_to do |f|
      f.json {render :layout=>false, :json=>@plate_json}
    end
  end

  def show_plate_exercise
    @exercise = Exercise.find_by_id(params[:id])
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
