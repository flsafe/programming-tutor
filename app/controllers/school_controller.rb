class SchoolController < ApplicationController
  def index
    logger.info "user id: #{session[:user_id]}"
    @exercise_sets = ExerciseSet.recommend(session[:user_id])
  end
end