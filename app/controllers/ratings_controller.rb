class RatingsController < ApplicationController
  
  before_filter :require_user

  def create
    Rating.create(:user_id=>current_user.id, 
                   :exercise_id=>params[:exercise_id],
                   :rating=>Rating.to_value(params[:rating]))

    render :text=>""
  end
end
