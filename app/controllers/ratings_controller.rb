class RatingsController < ApplicationController
  
  before_filter :require_user

  def create
    Rating.create!(:user_id=>current_user.id, 
                   :exercise_id=>params[:exercise_id],
                   :rating=>rating_value)

    render :text=>""
  end

  protected

  def rating_value
    rating_str = params[:rating].sub(/\-/, '_')
    rating = APP_CONFIG['rating_values'][rating_str]
  end
end
