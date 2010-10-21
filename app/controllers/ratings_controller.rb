class RatingsController < ApplicationController
  
  before_filter :require_user

  def create
    if current_user.grade_for? params[:id]
      Rating.create! :user_id=>current_user.id, 
        :exercise_id=>params[:id],
        :rating=>params[:rating]
    end
end
