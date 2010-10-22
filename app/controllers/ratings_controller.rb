class RatingsController < ApplicationController
  
  before_filter :require_user

  def create
    rating = APP_CONFIG['rating_values'][params['rating']]

    Rating.create!(:user_id=>current_user.id, 
                   :exercise_id=>params[:exercise_id],
                   :rating=>rating)

    render :text=>""
  end
end
